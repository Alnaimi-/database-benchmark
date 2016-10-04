class Person:
    """Models a Person on LDBC data. Languages and emails are used has an array, as described in the LDBC-SNB data
    schema"""
    id = 0
    firstName = ""
    lastName = ""
    gender = ""
    birthday = ""
    creationDate = ""
    locationIP = ""
    browserUsed = ""
    listOfLanguages = []
    listOfEmails = []
    languages = ""
    emails = ""

    def __init__(self, row):
        self.id = row["id"]
        self.firstName = row["firstName"]
        self.lastName = row["lastName"]
        self.gender = row["gender"]
        self.birthday = row["birthday"]
        self.creationDate = row["creationDate"]
        self.locationIP = row["locationIP"]
        self.browserUsed = row["browserUsed"]
        self.listOfLanguages = []
        self.listOfEmails = []

    @staticmethod
    def csvFields():
        return ["id", "firstName", "lastName", "gender", "birthday", "creationDate", "locationIP", "browserUsed",
                "languages", "emails"]

    def prepareToSerialization(self):
        lang = map(lambda x: str(x), self.listOfLanguages)
        self.languages = ';'.join(lang)

        mail = map(lambda x: str(x), self.listOfEmails)
        self.emails = ';'.join(mail)
