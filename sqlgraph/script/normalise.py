
# coding: utf-8

import os
import csv
import re
import sys
import inspect

cmd_folder = os.path.realpath(os.path.abspath(os.path.split(inspect.getfile( inspect.currentframe() ))[0]))
if cmd_folder not in sys.path:
    sys.path.insert(0, cmd_folder)

try:
    import pyprind
    installed = True
except ImportError:
    installed = False # not installed

if (len(sys.argv) >= 1):
    ldbcPath = sys.argv[1]
    outPath = sys.argv[2]
else:
    print ("[ERROR] Wrong usage. Is it being run through the script?")
    exit(1)

if not os.path.exists(ldbcPath):
    print ("[ERROR] LDBC folder " + ldbcPath + " does no exist.")
    exit(2)

def appendUsage(data):
    with open(outPath + "/conversion.log", "a") as f:
        f.write(str(data) + '\n\n')

# Set current directory
print('Data will be printed to', outPath, '\n')

# Make normalised directory if not already exist
if not os.path.exists(outPath + '/normalised'): os.makedirs(outPath + '/normalised')

# Retrieve all csv files in ldbc directory
files = os.listdir(ldbcPath)
lf = max([len(x) for x in files])

# Get graph entities by regex matching
entities = [x for x in files if re.match(r'[a-zA-Z]*_0_0.csv', x)]

# Normalise entities too, so append to list
entities += ['person_complete_0_0.csv']

# Find all other files representing graph relationships
relations = [x for x in files if x not in entities and x.endswith('.csv')]

# print(relations)
# print(entities)

# #### Find the largest ID in all entities, this helps serve as basis for the id length normalization

print("# Performing id normalisation across data")
print("# -----------------------------------------------------------------------------------------------\n")

largest = 0
largestIn = ''

if installed: bar = pyprind.ProgPercent(len(entities), title='Searching for largest id', monitor=True)
for filename in entities:
    with open(ldbcPath + '/' + filename, "r") as f:
        reader = csv.reader(f, delimiter="|")

        next(reader)

        maxid = max([int(row[0]) for row in reader])

        if maxid > largest:
            largest = maxid
            largestIn = filename

    if installed: bar.update(item_id = filename + " "*(lf-len(filename)))

if installed:
    appendUsage(bar)
    print('\n')

# print(str(largest) + " is largest ID, found in: " + largestIn, '\n')

largestLength = str(len(str(largest))) + 'd'

# #### Given above, normalize each ID in the tables, and prepend 'prefix' to categorise, then write out new formated data into the directory 'normalised'. This is done to avoid pk clash in SQL

# Make number n in length of biggest id
# prepend prefix (category) p
format = lambda p,n: str(p) + (u'%0' + largestLength) % int(n)

dict = {'continent': 10, 'country': 10, 'city': 10,
        'place': 10, 'company': 11, 'university': 11,
        'organisation': 11, 'person': 15, 'post': 25,
        'tag': 30, 'tagclass': 32, 'comment': 33,
        'forum': 43}

# Test with num 993
# print("Test normalisation: " + format('81', 993))

# For every id column, normalize length
if installed: bar = pyprind.ProgPercent(len(entities), title='Normalising entitiy Id to avoid clashing', monitor=True)
for filename in entities:
    with open(ldbcPath + "/" + filename, "r") as f,\
    open(outPath + '/normalised/' + filename, "w") as g:
        reader = csv.reader(f, delimiter="|")
        writer = csv.writer(g, delimiter="|")

        # Make sure id in first column
        # print(next(reader))

        # Writeout header line in CSV file
        # :-1 for all but last column (empty)
        writer.writerow(next(reader)[:-1])

        # RegEx to Remove _digit_digit.csv
        c = re.sub(r'_.*\.csv', '', filename)

        # Retrieve the prefix from dict
        prefix = dict[c]

        for row in reader:
            fid = [format(prefix, row[0])]
            data = row[1:-1]

            # append the new ids together with old data and write
            writer.writerow(fid + data)

    if installed: bar.update(item_id = filename + " "*(lf-len(filename)))

if installed:
    appendUsage(bar)
    print('\n')

# #### Do same as above for all relation tables. This matches around foreign keys e.g. Person.Id and Tag.Id

if installed: bar = pyprind.ProgPercent(len(relations), title='Normalising relation Id similar to above', monitor=True)
for filename in relations:
    with open(ldbcPath + "/" + filename, "r") as f,\
    open(outPath + '/normalised/' + filename, "w") as g:
        reader = csv.reader(f, delimiter="|")
        writer = csv.writer(g, delimiter="|")

        header = next(reader)
        writer.writerow(header)

        # For each column, check if column name contains .id (is foreign key)
        # Create dictionary of index in column as key and prefix as value
        colPrefix = {ind:dict[str.split(x, '.')[0].lower()] for ind, x in enumerate(header) if '.id' in x}

        # Get the range of the data
        r = range(len(header))

        for row in reader:
            # List comprehension, instead of extracting column
            # process them, and reinsert; linearly iterate through
            # the rows, if it's an id, then format else keep as is
            newRow = [format(colPrefix[ind], row[ind]) if ind in colPrefix else row[ind] for ind in r]

            # Write out the data
            writer.writerow(newRow)

    if installed: bar.update(item_id = filename + " "*(lf-len(filename)))

if installed:
    appendUsage(bar)
    print('\n')
