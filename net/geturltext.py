import requests

url ="https://github.com/hyw-num/info/blob/main/my.config" 
response = requests.get(url)
text = response.text
print(text)
