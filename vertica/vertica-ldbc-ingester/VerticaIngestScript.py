import os
import sys

import ldbcIO.TemplateManager as TemplateManager

# Main flow:

# Only one argument is accepted - path to ldbc 
if (sys.argv >= 1):
    ldbcPath = sys.argv[1];
else:
    print ("[ERROR] Wrong usage. Is it being run through the script?")
    exit(1)

if not os.path.exists(ldbcPath):
    print ("[ERROR] LDBC folder " + ldbcPath + " does no exist.")
    exit(2)

# remove '/' from the path end
if (ldbcPath[-1] == r'/'):
    ldbcPath = ldbcPath[0:-2]

# generate ingestionTemplate
tempManager = TemplateManager()
tempManager.populateSqlIngestionTemplate(ldbcPath)


