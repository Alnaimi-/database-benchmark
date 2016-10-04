import os
import shutil
import sys


def file_len(fname):
    with open(fname) as f:
        for i, l in enumerate(f):
            pass
    return i + 1

# Define file_splitter function
def node_splitter(fullfilepath, lines=50):
    #print(fullfilepath)
    path, filename = os.path.split(fullfilepath)
    basename, ext = os.path.splitext(filename)
    idSet = set()
    # Open source text file
    with open(fullfilepath, 'r') as f_in:
        header=""
        try:
            f_output = os.path.join(path+"/0", '{}{}'.format(basename, ext))
            f_out = open(f_output, 'w')
            print("Creating "+ f_output.title())

            # Read input file one line at a time
            for i, line in enumerate(f_in):
                split = line.split("|")

                if(i==0): #save header so can be written to both files
                    header = line

                # When current line can be divided by the line
                # count close the output file and open the next one
                if i == lines:
                    f_out.close()
                    f_output = os.path.join(path+"/1", '{}{}'.format(basename, ext))
                    f_out = open(f_output, 'w')
                    f_out.write(header) #add header to new files
                    print("Creating "+ f_output.title())

                # Write current line to output file
                f_out.write(line)
                #Adds all ids in first file to a set to be searched later. In if to not add ID
                if (i < lines):
                   idSet.add(split[0])

        finally:
            # Close last output file
            f_out.close()
        return idSet

def relation_splitter(startIDs, endIDs, relationFile):
    path, filename = os.path.split(relationFile)
    basename, ext = os.path.splitext(filename)

    with open(relationFile, 'r') as f_in:
        try:
            #create two relation files
            f_first = open(os.path.join(path + "/0", '{}{}'.format(basename, ext)), 'w')
            f_second = open(os.path.join(path + "/1", '{}{}'.format(basename, ext)), 'w')

            # Read input file one line at a time
            for i, line in enumerate(f_in):
                if (i == 0):  # write header to both files
                    f_first.write(line)
                    f_second.write(line)
                else:
                    split = line.split("|")
                    if((split[0] in startIDs) & (split[1] in endIDs)): #check if both ID's are contained in teh first block
                        f_first.write(line)
                    else:
                        f_second.write(line)
        finally:
            # Close last output file
            f_first.close()
            f_second.close()

###############################  MAIN  ###############################

if(len(sys.argv) >= 1):
    path = sys.argv[1]
    print(path)
else:
    print("Please run the populateNeo4j.sh script with the -s flag instead of this file.")
    sys.exit(1)

if not os.path.exists(path + "/0"):
    os.makedirs(path + "/0")
else:
    shutil.rmtree(path + "/0", ignore_errors=True)
    os.makedirs(path + "/0")

if not os.path.exists(path + "/1"):
    os.makedirs(path + "/1")
else:
    shutil.rmtree(path + "/1", ignore_errors=True)
    os.mkdir(path+"/1")

#Split all nodes into seperate files and store first file ids in set
personSet       = node_splitter(path+'/person_complete_0_0.csv',file_len(path+'/person_complete_0_0.csv')/2)
citySet         = node_splitter(path+'/city_0_0.csv', file_len(path+'/city_0_0.csv')/2)
countrySet      = node_splitter(path+'/country_0_0.csv',file_len(path+'/country_0_0.csv')/2)
continentSet    = node_splitter(path+'/continent_0_0.csv',file_len(path+'/continent_0_0.csv')/2)
forumSet        = node_splitter(path+'/forum_0_0.csv',file_len(path+'/forum_0_0.csv')/2)
postSet         = node_splitter(path+'/post_0_0.csv',file_len(path+'/post_0_0.csv')/2)
commentSet      = node_splitter(path+'/comment_0_0.csv',file_len(path+'/comment_0_0.csv')/2)
companySet      = node_splitter(path+'/company_0_0.csv',file_len(path+'/company_0_0.csv')/2)
universitySet   = node_splitter(path+'/university_0_0.csv',file_len(path+'/university_0_0.csv')/2)
tagSet          = node_splitter(path+'/tag_0_0.csv',file_len(path+'/tag_0_0.csv')/2)
tagClassSet     = node_splitter(path+'/tagclass_0_0.csv',file_len(path+'/tagclass_0_0.csv')/2)

organisationSet = companySet.union(universitySet)
placeSet = citySet.union(countrySet).union(continentSet)
messageSet = postSet.union(commentSet)
#split relations
#relations with Tag as source
relation_splitter(tagClassSet,tagClassSet,path+'/tagclass_isSubclassOf_tagclass_0_0.csv')
relation_splitter(tagSet,tagClassSet,path+'/tag_hasType_tagclass_0_0.csv')

#relations with person as source
relation_splitter(personSet,citySet,path+'/person_isLocatedIn_place_0_0.csv')
relation_splitter(personSet,personSet,path+'/person_knows_person_0_0.csv')
relation_splitter(personSet,tagSet,path+'/person_hasInterest_tag_0_0.csv')
relation_splitter(personSet,postSet,path+'/person_likes_post_0_0.csv')
relation_splitter(personSet,commentSet,path+'/person_likes_comment_0_0.csv')
relation_splitter(personSet,universitySet,path+'/person_studyAt_organisation_0_0.csv')
relation_splitter(personSet,companySet,path+'/person_workAt_organisation_0_0.csv')

#relations with organisation as source
relation_splitter(organisationSet,placeSet, path+'/organisation_isLocatedIn_place_0_0.csv')

#relations with place as source
relation_splitter(placeSet,placeSet,path+'/place_isPartOf_place_0_0.csv')

#relations with message as source
relation_splitter(commentSet,personSet,path+'/comment_hasCreator_person_0_0.csv')
relation_splitter(postSet,personSet,path+'/post_hasCreator_person_0_0.csv')
relation_splitter(commentSet,tagSet,path+'/comment_hasTag_tag_0_0.csv')
relation_splitter(postSet,tagSet,path+'/post_hasTag_tag_0_0.csv')
relation_splitter(messageSet,messageSet,path+'/comment_replyOf_comment_0_0.csv')
relation_splitter(commentSet,postSet,path+'/comment_replyOf_post_0_0.csv')
relation_splitter(commentSet,placeSet,path+'/comment_isLocatedIn_place_0_0.csv')
relation_splitter(postSet,placeSet,path+'/post_isLocatedIn_place_0_0.csv')

#relationships with forum as source
relation_splitter(forumSet,personSet,path+'/forum_hasMember_person_0_0.csv')
relation_splitter(forumSet,personSet,path+'/forum_hasModerator_person_0_0.csv')
relation_splitter(forumSet,postSet,path+'/forum_containerOf_post_0_0.csv')
relation_splitter(forumSet,tagSet,path+'/forum_hasTag_tag_0_0.csv')