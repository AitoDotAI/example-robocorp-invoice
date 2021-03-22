# +
from RPA.Robocloud.Secrets import Secrets

secrets = Secrets()
AITO_API_URL = secrets.get_secret("credentials")["aito_api_url"]
AITO_API_KEY = secrets.get_secret("credentials")["aito_api_key"]
G_SHEET_ID = secrets.get_secret("credentials")["g_sheet_id"]
