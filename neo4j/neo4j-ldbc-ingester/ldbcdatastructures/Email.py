class Email(object):
    """Models e-mails addresses in LDBC. A person can have multiple e-mail addresses."""
    personId = 0
    email = ""

    def __init__(self, row):
        self.personId = row['Person.id']
        self.email = row['email']

    def __str__(self):
        """Returns the email address"""
        return str(self.email)
