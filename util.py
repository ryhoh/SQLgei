import json


CREDENTIAL = 'credential.json'


def load_credential() -> dict:
    with open(CREDENTIAL, 'r') as f:
        return json.load(f)
