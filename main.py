from flask import Flask, request, redirect, url_for, render_template, send_from_directory
# import subprocess
# import json

app = Flask(__name__)

@app.route('/',methods=['GET', 'POST'])
def show_page():
    return "yo"

if __name__ == "__main__":
    app.run(debug=True)