import csv


def importFromLDBCData(filePath):
    """Read a list of rows from the CSV datafile"""

    infoRows = []
    with open(filePath) as csvfile:
        rows = csv.DictReader(csvfile, dialect="LDBCDialect");

        for row in rows:
            infoRows.append(row)
    return infoRows


def exportToLDBCData(fieldNames, objects, filePath):
    """Exports the object to a new csv file."""
    with open(filePath, 'w') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldNames, dialect="LDBCDialect")
        writer.writeheader()

        for object in objects:
            getAttributeValues = lambda attributeName: getattr(object, attributeName)
            attributes = map(getAttributeValues, fieldNames)
            objectInfo = dict(zip(fieldNames, attributes))
            writer.writerow(objectInfo)
