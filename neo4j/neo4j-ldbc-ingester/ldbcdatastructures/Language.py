class Language(object):
    """Models languages that a person speaks in LDBC. A person can speak multiple languages."""
    personId = 0
    language = ""

    def __init__(self, row):
        self.personId = row['Person.id']
        self.language = row['language']

    def __str__(self):
        """Returns the language address"""
        return str(self.language)
