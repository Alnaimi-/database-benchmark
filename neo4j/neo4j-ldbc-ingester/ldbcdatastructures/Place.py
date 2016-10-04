class Place:
    """Models places on LDBC data."""
    id = 0
    name = ""
    url = ""
    type = ""

    def __init__(self, row):
        self.id = row["id"]
        self.name = row["name"]
        self.url = row["url"]
        self.type = row["type"]

    @staticmethod
    def csvFields():
        return ["id", "name", "url"]
