import os
import sys

import ldbcIO.CSVHandler as iohandler
import ldbcIO.TemplateManager as TemplateManager
import ldbcdatastructures.Email as Email
import ldbcdatastructures.Language as Language
import ldbcdatastructures.Organisation as Organisation
import ldbcdatastructures.Person as Person
import ldbcdatastructures.Place as Place
from ldbcIO.definitions import Definitions


def populateInMemoryPeopleInfo(path):
    """ Returns a list of people, people-email and people-languages"""

    print ("[LOADING PERSON CSV FILES INTO MEMORY]")

    print (" - Loading file: " + Definitions.LDBCDefines.PERSON_FILE_NAME)
    rows = iohandler.importFromLDBCData(path + "/" + Definitions.LDBCDefines.PERSON_FILE_NAME)
    personList = []
    for row in rows:
        personList.append(Person(row))

    # Load emails csv file
    print (" - Loading file: " + Definitions.LDBCDefines.EMAIL_FILE_NAME)
    rows = iohandler.importFromLDBCData(path + "/" + Definitions.LDBCDefines.EMAIL_FILE_NAME)
    emailDict = dict()
    for row in rows:
        email = Email(row)
        if email.personId in emailDict:
            emailsOfPerson = emailDict[email.personId]
        else:
            emailsOfPerson = []

        emailsOfPerson.append(email)
        emailDict[email.personId] = emailsOfPerson

    # Load languages csv file
    print (" - Loading file: " + Definitions.LDBCDefines.LANGUAGE_FILE_NAME)
    rows = iohandler.importFromLDBCData(path + "/" + Definitions.LDBCDefines.LANGUAGE_FILE_NAME)
    languageDict = dict()
    for row in rows:
        language = Language(row)
        if language.personId in languageDict:
            languagesOfPerson = languageDict[language.personId]
        else:
            languagesOfPerson = []

        languagesOfPerson.append(language)
        languageDict[language.personId] = languagesOfPerson

    return personList, emailDict, languageDict


def mergeEmails(listOfPeople, emailsDict):
    """ Merge emails CSV to People"""

    print (" - Merging Emails with Person")
    for person in listOfPeople:
        emails = emailsDict.get(person.id)

        if emails:
            person.listOfEmails = emails


def mergeLanguages(listOfPeople, languagesDict):
    """ Merge languages CSV to People"""

    print (" - Merging Languages With Person")
    for person in listOfPeople:
        languages = languagesDict.get(person.id)

        if languages:
            person.listOfLanguages = languages


def exportPeopleToLDBCData(listOfPeople, ldbcPath):
    """Exports all person information a new csv file"""

    # Prepare persons to serialization process
    map(lambda person: person.prepareToSerialization(), listOfPeople)

    exportLDBCEntity(ldbcPath, listOfPeople)


def exportPeopleToLDBCData(listOfPeople, ldbcPath):
    """Exports all person information a new csv file"""

    # Prepare persons to serialization process
    map(lambda person: person.prepareToSerialization(), listOfPeople)
    fieldNames = Person.csvFields()
    exportLDBCEntity(ldbcPath + "/" + Definitions.LDBCDefines.MERGED_FILE_NAME, listOfPeople, fieldNames)


def exportPlacesSplitsToLDBCData(listOfCities, listOfCountries, listOfContinents, ldbcPath):
    """Generates a csv file to cities, countries and continents"""

    fieldNames = Place.csvFields()
    exportLDBCEntity(ldbcPath + "/" + Definitions.LDBCDefines.CITIES_FILE_NAME, listOfCities, fieldNames)
    exportLDBCEntity(ldbcPath + "/" + Definitions.LDBCDefines.COUNTRIES_FILE_NAME, listOfCountries, fieldNames)
    exportLDBCEntity(ldbcPath + "/" + Definitions.LDBCDefines.CONTINENTS_FILE_NAME, listOfContinents, fieldNames)


def exportLDBCEntity(path, listOfLDBCEntities, fieldNames):
    """Exports the LDBC entity back to csv format"""
    print (" - Exporting to file: " + path)
    iohandler.exportToLDBCData(fieldNames, listOfLDBCEntities, path)


def loadPlacesAndSplit(path):
    """Loads all places and split between cities, countries and continent"""

    print ("[LOADING PLACES CSV FILES INTO MEMORY]")
    print (" - Loading file: " + Definitions.LDBCDefines.PLACES_FILE_NAME)
    rows = iohandler.importFromLDBCData(path + "/" + Definitions.LDBCDefines.PLACES_FILE_NAME)

    placeList = []

    for row in rows:
        placeList.append(Place(row))

    cityList = filter(lambda place: place.type == "city", placeList)
    countryList = filter(lambda place: place.type == "country", placeList)
    continentList = filter(lambda place: place.type == "continent", placeList)

    return cityList, countryList, continentList


def loadOrganisationsAndSplit(path):
    """Loads all organisations and split between companies and universities"""

    print ("[LOADING ORGANISATION CSV FILES INTO MEMORY]")
    print (" - Loading file: " + Definitions.LDBCDefines.ORGANISATION_FILE_NAME)
    rows = iohandler.importFromLDBCData(path + "/" + Definitions.LDBCDefines.ORGANISATION_FILE_NAME)

    organisationList = []

    for row in rows:
        organisationList.append(Organisation(row))

    universityList = filter(lambda place: place.type == "university", organisationList)
    companiesList = filter(lambda place: place.type == "company", organisationList)

    return universityList, companiesList


def exportOrganisationsSplitsToLDBCData(listOfUniversities, listOfCompanies, ldbcPath):
    """Generates a csv file to cities, countries and continents"""

    fieldNames = Organisation.csvFields()
    exportLDBCEntity(ldbcPath + "/" + Definitions.LDBCDefines.UNIVERSITY_FILE_NAME, listOfUniversities, fieldNames)
    exportLDBCEntity(ldbcPath + "/" + Definitions.LDBCDefines.COMPANY_FILE_NAME, listOfCompanies, fieldNames)

def mergeFiles():
    # Merge people, emails and languages csv files:
    listOfPeople, emailsDict, languagesDict = populateInMemoryPeopleInfo(ldbcPath)

    mergeEmails(listOfPeople, emailsDict)
    mergeLanguages(listOfPeople, languagesDict)

    exportPeopleToLDBCData(listOfPeople, ldbcPath)

    # split places into cities, countries and continents
    listOfCities, listOfCountries, listOfContinents = loadPlacesAndSplit(ldbcPath)
    exportPlacesSplitsToLDBCData(listOfCities, listOfCountries, listOfContinents, ldbcPath)

    # split organization into university and companies
    listOfUniversities, listOfCompanies = loadOrganisationsAndSplit(ldbcPath)
    exportOrganisationsSplitsToLDBCData(listOfUniversities, listOfCompanies, ldbcPath)

# Main flow:

# Only two argument is accepted - path to ldbc and target (vertica / cypher)
if (sys.argv >= 2):
    ldbcPath = sys.argv[1];
    target = sys.argv[3];
else:
    print ("[ERROR] Wrong usage. Is it being run through the script?")
    exit(1)

if not os.path.exists(ldbcPath):
    print ("[ERROR] LDBC folder " + ldbcPath + " does no exist.")
    exit(2)

# remove '/' from the path end
if (ldbcPath[-1] == r'/'):
    ldbcPath = ldbcPath[0:-2]

if os.path.isfile(ldbcPath+"/person_complete_0_0.csv"):
    ans = raw_input('Would you like to overwrite the previous merge files (will overwrite header changes) [y/n]: ')
    if (ans=='y'):
        mergeFiles()
    else:
        print("Leaving Merged files alone")
else:
    mergeFiles()

if(sys.argv > 2):

    if(sys.argv[2]=="Split"):
        # generate ingestionTemplate
        tempManager = TemplateManager()
        tempManager.populateCypherIngestionTemplate(ldbcPath+"/1")

    if(sys.argv[2] == "Load_CSV"):
        # generate ingestionTemplate
        tempManager = TemplateManager()
	if (target == 'neo4j'):
        	tempManager.populateCypherIngestionTemplate(ldbcPath)
	elif (target == 'vertica'):
        	tempManager.populateSqlIngestionTemplate(ldbcPath)


