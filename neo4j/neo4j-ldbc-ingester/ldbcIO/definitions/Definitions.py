class LDBCDefines(object):
    # LDBC information:
    PERSON_FILE_NAME = "person_0_0.csv"
    EMAIL_FILE_NAME = "person_email_emailaddress_0_0.csv"
    LANGUAGE_FILE_NAME = "person_speaks_language_0_0.csv"
    MERGED_FILE_NAME = "person_complete_0_0.csv"

    PLACES_FILE_NAME = "place_0_0.csv"
    CITIES_FILE_NAME = "city_0_0.csv"
    COUNTRIES_FILE_NAME = "country_0_0.csv"
    CONTINENTS_FILE_NAME = "continent_0_0.csv"

    ORGANISATION_FILE_NAME = "organisation_0_0.csv"
    UNIVERSITY_FILE_NAME = "university_0_0.csv"
    COMPANY_FILE_NAME = "company_0_0.csv"

    # Template information:
    TEMPLATE_FILE_PATH = "resources/templates"
    TEMPLATE_FILE_NAME = "ingestionTemplate.cypher"
    SQL_TEMPLATE_FILE_NAME = "ingestionTemplate.sql"
    OUTPUT_SQL_FILE_NAME = "ingestion.sql"
    OUTPUT_CYPHER_FILE_NAME = "ingestion.cypher"
