import json
import os
import requests 
from flask import Flask, jsonify
app = Flask(__name__)

RESPONSE = os.environ["RESPONSE"] = 'success'

@app.route('/')
def greating():
	hi = 'Hello there Good People'

	return hi

@app.route('/status')
def root() :
	ret = {
		'response': RESPONSE
	}

	return json.dumps(ret)

@app.route('/ip')
def take_ip():
    url = requests.get('http://ipinfo.io/json').json()
    ip = url['ip']
    city = url['city']
    state = url['region']
    info = jsonify({'ip': ip, 'city': city, 'state': state}), 200
    return info
if __name__ == '__main__':
    app.run(host='0.0.0.0')