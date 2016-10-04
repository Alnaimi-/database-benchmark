class Organisation:
    """Models organisations on LDBC data."""
    id = 0
    type = ""
    name = ""
    url = ""

    def __init__(self, row):
        self.id = row["id"]
        self.name = row["name"]
        self.url = row["url"]
        self.type = row["type"]

    @staticmethod
    def csvFields():
        return ["id", "name", "url"]
