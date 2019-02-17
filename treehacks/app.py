from flask import Flask, render_template, request, redirect, make_response
import requests
import sqlite3
import pyrebase
import os
import sys
from twilio.rest import Client
import json
from watson_developer_cloud import NaturalLanguageUnderstandingV1
from watson_developer_cloud.natural_language_understanding_v1 import Features, CategoriesOptions

config = {
    "apiKey": "AIzaSyCaY4mqwMRYMY9HdgBJ8yuo63SLDXtuE4c",
    "authDomain": "treehacks-247bf.firebaseapp.com",
    "databaseURL": "https://treehacks-247bf.firebaseio.com",
    "projectId": "treehacks-247bf",
    "storageBucket": "treehacks-247bf.appspot.com",
    "messagingSenderId": "1032236352208"
 }

firebase = pyrebase.initialize_app(config)
auth = firebase.auth()
user = "err"
db = firebase.database()

app = Flask(__name__)

base_url = 'treehacks-247bf.firebaseapp.com'

@app.route('/')
@app.route('/home')
def home():
	return render_template('home.html', coins=0)

@app.route('/sign-in')
def signin():
	user = auth.sign_in_with_email_and_password("germans@stanford.edu", "testing")
	print(user)
	return render_template('home.html', coins=0)

@app.route('/get-coins')
def getCoins(): 
	data = {"coins": 10}
	users = db.child("users").get()
	print(users)
	german = "trash"
	for user in users.each():
	    if user.key() == "ZI6CoYf06HeRH1izINg0mECeR4j1":
	    	german = user.val()
	print(german["numCoins"])
	return render_template('home.html', coins=german["numCoins"])

@app.route('/increment-coins')
def setCoins():
	data = {"coins": 10}
	users = db.child("users").get()
	print(users)
	german = "trash"
	for user in users.each():
	    if user.key() == "ZI6CoYf06HeRH1izINg0mECeR4j1":
	    	german = user.val()
	# set coins to be coins + 60 in database
	db.child("users").child("ZI6CoYf06HeRH1izINg0mECeR4j1").update({"numCoins": (german["numCoins"] + 60)})
	return render_template('home.html', coins=(german["numCoins"]))

@app.route('/send-text')
def sendText():
	# Your Account Sid and Auth Token from twilio.com/console
	account_sid = 'AC80d7a731c11fcc3dc5b66cc8d689c1d6'
	auth_token = '1a51b92339916ef5289411a471d381b1'
	client = Client(account_sid, auth_token)

	#get first input argument, the text the child input
	childText = str(sys.argv[1:2])

	message = client.messages.create(
                     body="TESTING",
                     from_='++16502295281',
                     to='+2018889099'
                 )
	return render_template('home.html')


if __name__ == '__main__':
	app.run(host="0.0.0.0")