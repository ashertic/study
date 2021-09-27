import requests


def id_card(ip):
  url = "http://{0}/v1/api/workflows/6038af97-6908-471a-8d3c-edd8372626bd?appKey=7cb967d0-71bb-11ea-88a9-91cf8b9032a5&appSecret=7cb967d1-71bb-11ea-88a9-91cf8b9032a5".format(
      ip)
  print(url)
  payload = {}
  files = [
      ('', open('id_card.jpg', 'rb'))
  ]
  headers = {
      'Accept': 'application/json',
      'Cookie': 'locale=zh-cn'
  }

  response = requests.request(
      "POST", url, headers=headers, data=payload, files=files)

  print(response.text.encode('utf8'))
  return


def id_card_back(ip):
  url = "http://{0}/v1/api/workflows/2415b5ff-3781-4660-a985-5f68e81fdaa0?appKey=7cb967d0-71bb-11ea-88a9-91cf8b9032a5&appSecret=7cb967d1-71bb-11ea-88a9-91cf8b9032a5".format(
      ip)

  payload = {}
  files = [
      ('', open('id_card_back.jpg', 'rb'))
  ]
  headers = {
      'Accept': 'application/json',
      'Cookie': 'locale=zh-cn'
  }

  response = requests.request(
      "POST", url, headers=headers, data=payload, files=files)

  print(response.text.encode('utf8'))


def budongchanProperty(ip):
  url = "http://{0}/api/v1/c/approval?appKey=e6e6b952-c754-4203-8511-891b7274cec8&appSecret=3df587ce-bcda-4eb5-857f-0a7da4ada188&type=propertyCert".format(
      ip)

  payload = {'name': '刘艳红',
             'address': '新泾三村25号502室'}
  files = [
      ('file', open('shanghai_property.jpg', 'rb'))
  ]
  headers = {
      'Cookie': 'locale=zh-cn'
  }

  response = requests.request(
      "POST", url, headers=headers, data=payload, files=files)

  print(response.text.encode('utf8'))


def rent(ip):
  url = "http://{0}/api/v1/c/approval?appKey=e6e6b952-c754-4203-8511-891b7274cec8&appSecret=3df587ce-bcda-4eb5-857f-0a7da4ada188&type=rentalCert".format(
      ip)

  payload = {'name': '陈曦',
             'address': '福泉路495弄37号402室402'}
  files = [
      ('file', open('shanghai_rent.jpg', 'rb'))
  ]
  headers = {
      'Cookie': 'locale=zh-cn'
  }

  response = requests.request(
      "POST", url, headers=headers, data=payload, files=files)

  print(response.text.encode('utf8'))


def propertyRegistrationCertChina(ip):
  url = "http://{0}/api/v1/c/approval?appKey=e6e6b952-c754-4203-8511-891b7274cec8&appSecret=3df587ce-bcda-4eb5-857f-0a7da4ada188&type=propertyRegistrationCertChina".format(
      ip)

  payload = {'name': '严奂',
             'address': '虹桥机场新村137号601室'}
  files = [
      ('file', open('quanguobudongchan.jpg', 'rb'))
  ]
  headers = {
      'Cookie': 'locale=zh-cn'
  }

  response = requests.request(
      "POST", url, headers=headers, data=payload, files=files)

  print(response.text.encode('utf8'))


def propertyCertChina(ip):
  url = "http://{0}/api/v1/c/approval?appKey=e6e6b952-c754-4203-8511-891b7274cec8&appSecret=3df587ce-bcda-4eb5-857f-0a7da4ada188&type=propertyCertChina".format(
      ip)

  payload = {'name': '严奂',
             'address': '虹桥机场新村137号601室'}
  files = [
      ('file', open('quanguobudongchan.jpg', 'rb'))
  ]
  headers = {
      'Cookie': 'locale=zh-cn'
  }

  response = requests.request(
      "POST", url, headers=headers, data=payload, files=files)

  print(response.text.encode('utf8'))


if __name__ == '__main__':
  import sys

  expert_ip = sys.argv[1]
  approval_ip = sys.argv[2]

  print('expert ip is ' + expert_ip)
  print('approval ip is ' + approval_ip)

  print('*' * 80)
  print("Testing id_card api")
  id_card(expert_ip)

  print('*' * 80)
  print("Testing id_card_back api")
  id_card_back(expert_ip)

  print('*' * 80)
  print("Testing approval property api")
  budongchanProperty(approval_ip)

  print('*' * 80)
  print("Testing approval rent api")
  rent(approval_ip)

  print('*' * 80)
  print("Testing approval propertyRegistrationCertChina api")
  propertyRegistrationCertChina(approval_ip)

  print('*' * 80)
  print("Testing approval propertyCertChina api")
  propertyCertChina(approval_ip)
