import csv


class LDBCDialect(csv.excel):
    """Describe the usual properties of LDBC-generated CSV files."""
    # LDBC Dialect uses "|" character as field delimiter
    delimiter = '|'
    lineterminator = '|' + '\r\n'


# Register on first class reference
csv.register_dialect("LDBCDialect", LDBCDialect)
