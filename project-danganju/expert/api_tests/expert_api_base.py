import base64
import urllib
import requests
import json
import sys


class ExpertApiRequest:
    def __init__(self, endpoint, expert_api_config):
        workspace_id = expert_api_config['workspace_id']
        app_key = expert_api_config['app_key']
        app_secret = expert_api_config['app_secret']
        url = f'http://{endpoint}/v1/api/{workspace_id}?appKey={app_key}&appSecret={app_secret}'
        self.url = url

    def post(self, filename):
        try:
            f = open(filename, 'rb')
            fbuf = f.read()

            payload = {}
            files = [('default', open(filename, 'rb'))]
            headers = {
                'Accept': 'application/json'
            }
            response = requests.request('POST', self.url, headers=headers, data=payload, files=files)
            if response and response.status_code == 200:
                response = response.text
                result = json.loads(response)
                return result
            else:
                return None
        except Exception as e:
            # print(e)
            pass
        return None

    @classmethod
    def api(cls, endpoint, expert_api_config, filename, detail_output=False):
        req = cls(endpoint, expert_api_config)
        result = req.post(filename)
        if detail_output:
            print(result)
        return result
