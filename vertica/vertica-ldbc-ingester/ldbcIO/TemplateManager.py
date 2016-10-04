from jinja2 import FileSystemLoader, Environment

from ldbcIO.definitions import Definitions


class TemplateManager:
    """Singleton Template Manager. Used to populate the sql templates."""
    _instances = {}

    env = None

    """Singleton"""

    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super(TemplateManager, cls).__call__(*args, **kwargs)
        return cls._instances[cls]

    def populateSqlIngestionTemplate(self, ldbcPath):
        print ("[WRITING SQL FILE FROM TEMPLATE]")
        template = TemplateManager.env.get_template(Definitions.LDBCDefines.SQL_TEMPLATE_FILE_NAME)
        validSql = template.render(LDBC_LOCATION=ldbcPath)

        with open(Definitions.LDBCDefines.OUTPUT_SQL_FILE_NAME, "w") as sqlFile:
            print (" - Exporting to file: " + Definitions.LDBCDefines.OUTPUT_SQL_FILE_NAME)
            sqlFile.write(validSql)
            sqlFile.close()

    @staticmethod
    def initTemplateManager():
        templateLoader = FileSystemLoader(searchpath=Definitions.LDBCDefines.TEMPLATE_FILE_PATH)
        TemplateManager.env = Environment(loader=templateLoader)


# Creates Environment object on application initialisation
TemplateManager.initTemplateManager()
