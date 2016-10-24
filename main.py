from flask import Flask, request, redirect, url_for, render_template, send_from_directory
from engine.find_words import get_data
from engine.db import SQLConnection
import json
# import subprocess
# import json

app = Flask(__name__)

@app.route('/',methods=['GET', 'POST'])
def show_page():
	return "hei"

@app.route('/speech',methods=['GET', 'POST'])
def interpret_string():
	data=request.get_json(force=True)
	text=data["speech"].lower()
	SQLConnection().send_data(text)
	the_data=get_data().send_json(text)
	print data
	
	print "#######################"
	if the_data!=False:
		other=json.loads(the_data)
		return str(other["ID"])
	else:
		return text
	
@app.route('/speech_get',methods=['GET', 'POST'])
def junk():
	return SQLConnection().get_data()
	
if __name__ == "__main__":
    app.run(debug=True)