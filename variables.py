# +
from RPA.Robocorp.Vault import Vault

_secrets = Vault().get_secret("credentials")
AITO_API_URL = _secrets["aito_api_url"]
AITO_API_KEY = _secrets["aito_api_key"]
G_SHEET_ID = _secrets["g_sheet_id"]
