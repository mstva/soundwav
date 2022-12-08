from .base import *

DEBUG = True

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get("POSTGRES_DB"),
        'USER': os.environ.get("POSTGRES_USER"),
        'PASSWORD': os.environ.get("POSTGRES_PASSWORD"),
        'HOST': os.environ.get("POSTGRES_HOST"),
        'PORT': os.environ.get("POSTGRES_PORT"),
    }
}

GS_BUCKET_NAME = os.environ.get('GS_BUCKET_NAME')
GS_CUSTOM_ENDPOINT = os.environ.get('GS_CUSTOM_ENDPOINT')

from google.oauth2 import service_account
CREDENTIALS_PATH = os.path.join(BASE_DIR, '.gcp_creds.json')
GS_CREDENTIALS = service_account.Credentials.from_service_account_file(CREDENTIALS_PATH)

STATICFILES_STORAGE = 'src.storage.StaticStorage'
DEFAULT_FILE_STORAGE = 'src.storage.MediaStorage'
