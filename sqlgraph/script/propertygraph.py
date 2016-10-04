
# coding: utf-8

import os
import re
import csv
import json
import sys
from itertools import groupby

try:
    import pyprind
    installed = True
except ImportError:
    installed = False # not installed

if (len(sys.argv) >= 1):
    inPath = sys.argv[1]
else:
    print ("[ERROR] Wrong usage. Is it being run through the script?")
    exit(1)

def appendUsage(data):
    with open(inPath + "/conversion.log", "a") as f:
        f.write(str(data) + '\n')

# print("Current directory: ", path, '\n')

# Retrieve all csv files in current directory
files = os.listdir(inPath + '/normalised')
lf = max([len(x) for x in files])

# Make JSON directory if not already exist
if not os.path.exists(inPath + '/json/va'):
    os.makedirs(inPath + '/json/va')
    os.makedirs(inPath + '/json/ea')

# Make Adjacency directory if not already exist
if not os.path.exists(inPath + '/adjacency'):
    os.makedirs(inPath + '/adjacency/opa')
    os.makedirs(inPath + '/adjacency/osa')
    os.makedirs(inPath + '/adjacency/ipa')
    os.makedirs(inPath + '/adjacency/isa')

vatags = {'person_complete', 'place_0', 'comment_0', 'post_0', 'forum_0', 'tag_0', 'tagclass_0', 'organisation_0'}

# If any of the files in current directory matches the
# set of JSON files to be parsed, append to list
vattrFiles = [file for file in files if any(file.startswith(tag) for tag in vatags)]

# Not sure how else to distinct relationship files from others
# Alternatively read file and check if contains >2.ID columns
# Expensive IO time however.
eatags = {'At', '_has', '_is', 'study', 'Of', 'knows', 'likes'}
eattrFiles = [file for file in files if file not in vattrFiles and any(tag in file for tag in eatags)]

# print("Vertex attribute files: ", vattrFiles, '\n')
# print("Edge attribute files: ", eattrFiles, '\n')


# #### Function to convert from camelCase to underscore to follow schema constraint

# Function to convert from camel to underscore
regex = re.compile('([a-z0-9])([A-Z])')

def camelConvert(name):
    if(name in 'languages'): return 'SPEAKS'
    return regex.sub(r'\1_\2', name).upper()


# #### Below converts data from CSV relational form to SQLGraph or Property graphs
# By extracting the columns of interest for each entitiy (vertex) and appending the data to a JSON object containing the (camel to underscore) name as key and value. As some people have more than 1 email, the first is grabbed and the other ignored.


# Column(s) to extract for each vertex file
vattrDict = {
    'tagclass':['name']
    ,'tag':['name']
    ,'place':['name', 'type']
    ,'person':['firstName', 'lastName', 'gender',
        'birthday', 'creationDate', 'locationIp',
        'browserUsed', 'languages', 'emails']
    ,'forum':['title', 'creationDate']
    ,'comment':['content', 'length', 'creationDate',
        'locationIp', 'browserUsed']
    ,'post':['content', 'length', 'creationDate',
        'locationIp', 'browserUsed', 'imageFile', 'language']
    ,'organisation':['name', 'type']
}

print("# Converting and writing out data in SQLGraph format")
print("# -----------------------------------------------------------------------------------------------\n")

if installed: bar = pyprind.ProgPercent(len(vattrFiles), title='Converting entities to SQLGraph format', monitor=True)
for filename in vattrFiles:
   with open(inPath + '/normalised/' + filename, "r") as f,\
   open(inPath + '/json/va/' + filename, "w") as g:
       reader = csv.reader(f, delimiter="|")
       writer = csv.writer(g, delimiter="|",
           quoting=csv.QUOTE_NONE,
           quotechar='', escapechar='\\'
       )

       # Ignore old header, writeout new
       header = next(reader)
       writer.writerow(['VID','TYPE','ATTR'])

       # Retrieve the attribute headers for each file
       key = filename.split('_')[0]
       attrs = vattrDict[key]

       for row in reader:
           vid = row[0]
           data = {camelConvert(a):row[i].split(';')[0] for i, a in enumerate(header) if a in attrs}

           writer.writerow([vid] +[key]+ [json.dumps(data)])

   if installed: bar.update(item_id = filename + " "*(lf-len(filename)))

if installed:
   appendUsage(bar)
   print('\n')


# #### For each of the edge attribute files, do same as above
# Unlike the above however, this deals with edges and their attributes; the majority of which are or will be an empty set.


## TODO: ? SQLGraph paper suggests to encode attributes such
##         as creation date for comments in the EA table, to allow
##         for effecient filtering instead of EA Join on VA.
eattrDict = {
    'person':['creationDate', 'classYear', 'workFrom']
    ,'forum':['joinDate']
}

eid = 1

isLocated = {'comment':'M_IS_LOCATED_IN', 'post':'M_IS_LOCATED_IN', 'organisation':'O_IS_LOCATED_IN', 'person':'P_IS_LOCATED_IN'}

if installed: bar = pyprind.ProgPercent(len(eattrFiles), title='Converting relations to SQLGraph format', monitor=True)
for filename in eattrFiles:
   with open(inPath + '/normalised/' + filename, "r") as f,\
   open(inPath + '/json/ea/' + filename, "w") as g:
       reader = csv.reader(f, delimiter="|")
       writer = csv.writer(g, delimiter="|",
           quoting=csv.QUOTE_NONE,
           quotechar='', escapechar='\\'
       )

       # Ignore old header, writeout new
       header = next(reader)
       writer.writerow(['EID', 'INV','OUTV','LBL','ATTR'])

       # Get the different parts from filename
       segment = filename.split('_')
       key = segment[0]
       label = isLocated[key] if key in isLocated and segment[1] == "isLocatedIn" else camelConvert(segment[1])

       # Retrieve attributes associated
       attrs = eattrDict[key] if key in eattrDict else []

       for row in reader:
           # Grab the foreign keys first
           foreignKeys = [row[i] for i,j in enumerate(header) if '.id' in j]

           # And the edge attributes defined in the dictionary
           data = {camelConvert(a):row[i] for i, a in enumerate(header) if a in attrs}

           # Finally glue the row together and print
           writer.writerow([eid]+foreignKeys+[label]+[json.dumps(data)])

           eid += 1

   if installed: bar.update(item_id = filename + " "*(lf-len(filename)))

if installed:
   appendUsage(bar)
   print('\n')


# #### SELECT VID SPILL (0,1 if len(labels) > than available) [EID (null if several lbl), LBL, VAL (object id if lbl = 1 else OSA id, i.e. VALID]*
#
# http://static.googleusercontent.com/media/research.google.com/en//pubs/archive/43287.pdf
#
# * Please note that unsigned integers are being used to repreent the VALID in the Secondary Adjacency, this can be a problem depending on applicaiton usage (take for instance .NET which uses usngigned negative numbers to represent temporary rows, causing a clash)


# Lambda funciton to flatten list of lists
flatten = lambda l: [item for subl in l for item in subl]

def groupFiles(files, key):
    groups = []
    uniquekeys = []
    for k, g in groupby(sorted(eattrFiles, key=key), key):
       groups.append(list(g))    # Store group iterator as a list
       uniquekeys.append(k)
    return groups

opaFiles = groupFiles(eattrFiles, lambda f: f.split('_')[0])
ipaFiles = groupFiles(eattrFiles, lambda f: f.split('_')[2])

# Create a header for OPA and ISA
paHeader = ['VID', 'TYPE', 'SPILL'] + flatten([['EID%i' %i,'LBL%i' %i,'VAL%i'%i] for i in range(1,11)])

# print(*opaFiles, sep='\n')

# print("Format for adjacency headers: \n")
# print(paHeader[:6] + ['...', 'VAL10'], "\n")

# test set to check for clashes in VID
# Uncomment below deactivated code to
# enable this test
test = set()

print("# Producing adjacency tables for outgoing/incoming relations")
print("# -----------------------------------------------------------------------------------------------\n")

if installed: bar = pyprind.ProgPercent(len(opaFiles), title='Writing out outgoing adjacency tables', monitor=True)
for group in opaFiles:

    # Create a Key, Value set as VID+, SPILL, [EID, LBL, VAL]*
    OPA = {}
    # And a list as [VALID+, EID, VAL]
    OSA = [['VALID','TYPE','EID','VAL']]

    # Seconday table suffix, assuming a maximum of 9 relation
    # types (person), but can be higher (may create) issue
    # with schema if we don't spill
    fileSuffixCount = 2

    for filename in group:
        with open(inPath + '/json/ea/' + filename, "r") as f:
            reader = csv.reader(f, delimiter="|")

            segment = filename.split('_') # grab the first file in group
            sub = segment[0] # e.g. comment, post, person, etc
            rel = segment[1]

            # Get the header
            header = next(reader)
            #suffix = 0 if rel == "hasCreator" else 1 if rel == "isLocatedIn" and sub in ("comment", "post") else fileSuffixCount
            suffix = 0 if rel == "replyOf" else 1 if rel == "likes" else fileSuffixCount

            for row in reader:
                #VID+ SPILL ... EID_j LBL_j VAL_j ... EID_k LBL_k VAL_k
                o_vid = row[1]
                i_vid = row[2]
                spill = ''
                eid = row[0]
                lbl = row[3]

                # Construct secondary adjacency id
                # using signed ints to avoid clashing
                o_valid = '-%s%d' % (o_vid, suffix)

                # OPA[vid] = set()
                # The structure is {vid_1:{}, vid_2:{}, vid_k:{}}
                # where each vid:{lbl_1:{}, lbl_2:{}, lbl_k:{}}
                # and each lbl:{eid:X or null, val:Y or VALID}

                # Cold start, insert initial vid if not exist
                if o_vid not in OPA: OPA[o_vid] = {'type':sub, lbl:{'eid':eid, 'val':i_vid}}
                # else update it's values
                else:
                    if lbl in OPA[o_vid]:
                        # person_knows:{eid:123, val:456}
                        if '\\N' not in OPA[o_vid][lbl]['eid']:
                             OSA += [[o_valid,lbl,OPA[o_vid][lbl]['eid'],OPA[o_vid][lbl]['val']]]
                             OPA[o_vid][lbl] = {'eid':'\\N', 'val':o_valid}
                        OSA += [[o_valid,lbl,eid,i_vid]]
                        # test |= {(o_valid,sub)}

                    else: OPA[o_vid][lbl] = {'eid':eid, 'val':i_vid}

            fileSuffixCount += 1

    # Write out the OPA
    with open(inPath + '/adjacency/opa/' + sub + '.csv', "w") as f:
        writer = csv.writer(f, delimiter="|")

        # print out the header
        writer.writerow(paHeader)

        # And for each outgoin/incoming vertex
        for vid in OPA:
            # define the static data (VID, TYPE, SPILL)
            item = OPA[vid]
            data = [vid, item.pop('type'), '']

            # retrieve all relations, building a eid, lbl, val
            for k in item: data += [item[k]['eid'], k, item[k]['val']]

            # finally print out to file
            writer.writerow(data)

    with open(inPath + '/adjacency/osa/' + sub + '.csv', "w") as f:
        writer = csv.writer(f, delimiter="|")

        # simply write out each row in the list
        for row in OSA: writer.writerow(row)

    if installed: bar.update(item_id = filename + " "*(lf-len(filename)))

if installed:
    appendUsage(bar)
    print('\n')

test2 = set()

if installed: bar = pyprind.ProgPercent(len(ipaFiles), title='Writing out incoming adjacency tables', monitor=True)
for group in ipaFiles:

    # Create a Key, Value set as VID+, SPILL, [EID, LBL, VAL]*
    IPA = {}
    # And a list as [VALID+, EID, VAL]
    ISA = [['VALID','TYPE','EID','VAL']]

    # a suffix count for the current entity (person, place, comment, etc)
    fileSuffixCount = 1
    for filename in group:
        with open(inPath + '/json/ea/' + filename, "r") as f:
            reader = csv.reader(f, delimiter="|")

            segment = filename.split('_') # grab the first file in group and split
            sub = segment[0]
            rel = segment[1]
            obj = segment[2] # e.g. comment, post, person, etc

            # Skip the header
            next(reader)

            suffix = 0 if rel == "hasCreator" else 1 if rel == "hasTag" else 2 if rel == "isLocatedIn" and sub in ("comment", "post") else fileSuffixCount

            for row in reader:
                #VID+ SPILL ... EID_j LBL_j VAL_j ... EID_k LBL_k VAL_k
                o_vid = row[1]
                i_vid = row[2]
                spill = ''
                eid = row[0]
                lbl = row[3]

                valid = '-%s%d' % (i_vid, suffix)

                if i_vid not in IPA: IPA[i_vid] = {'type':obj, lbl:{'eid':eid, 'val':o_vid}}
                else:
                    # If the relation already exists
                    if lbl in IPA[i_vid]:
                        if '\\N' not in IPA[i_vid][lbl]['eid']:
                            ISA += [[valid,lbl,IPA[i_vid][lbl]['eid'],IPA[i_vid][lbl]['val']]]
                            IPA[i_vid][lbl] = {'eid':'\\N', 'val':valid}
                        ISA += [[valid,lbl,eid,o_vid]]
                        # test2 |= {(valid,obj)}

                    else: IPA[i_vid][lbl] = {'eid':eid, 'val':o_vid}

            fileSuffixCount += 1

    # Write out the OPA
    with open(inPath + '/adjacency/ipa/' + obj + '.csv', "w") as f:
        writer = csv.writer(f, delimiter="|")

        # print out the header
        writer.writerow(paHeader)

        # And for each outgoin/incoming vertex
        for vid in IPA:
            # define the static data (VID, TYPE, SPILL)
            item = IPA[vid]
            data = [vid, item.pop('type'), '']

            # retrieve all relations, building a eid, lbl, val
            for k in item: data += [item[k]['eid'], k, item[k]['val']]

            # finally print out to file
            writer.writerow(data)

    with open(inPath + '/adjacency/isa/' + obj + '.csv', "w") as f:
        writer = csv.writer(f, delimiter="|")

        # simply write out each row in the list
        for row in ISA: writer.writerow(row)

    if installed: bar.update(item_id = filename + " "*(lf-len(filename)))

if installed:
    appendUsage(bar)
    print('\n')

# Convert to list of keys
# a = [k[0] for k in test]
# b = [k[0] for k in test2]

# check for clashes bet ween place, person, etc
# by reduce by key
# print("O_VALID Doesn't clash" if len(a) == len(set(a)) else "VALID clashes", " in OSA.")
# print("I_VALID Doesn't clash" if len(b) == len(set(b)) else "VALID clashes", " in ISA.")
# print("\n")
