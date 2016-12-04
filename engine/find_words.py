from find_videos import getContent
import json
import time
from yt import yt
# conversation= Hello Russell How are you? Bla Bla Bla. From your symptoms it seems like 
# you have strep throat. I prescribe amoxicilin abortion ortion


class get_data():

	def __init__(self):
		print "created get_data object"

	def find_disease(self,conversation,condition):
		#print conversation.find(condition)
		if conversation.find(condition)>=0:
			# print conversation.find(condition)

			return condition

		else:
			# print conversation.find(condition)

			return False


	def find_medicine(self,conversation,medication):
		if conversation.find(medication):
			return medication

	def send_json(self,conversation):
		new_trip={} 
		diseases=[{"ID":113,"Name":"Pneumonia"},{"ID":170,"Name":"Abortion"},{"ID":509,"Name":"Accumulation of fluid in the scrotum"},{"ID":113,"Name":"Acute inflammation of lung"},{"ID":495,"Name":"Bloated belly"},{"ID":211,"Name":"Chronic tiredness syndrome"},{"ID":80,"Name":"Cold"},{"ID":53,"Name":"Constipation"},{"ID":86,"Name":"Coronary heart disease"},{"ID":47,"Name":"Depression"},{"ID":266,"Name":"Disturbed testicular descent"},{"ID":431,"Name":"Drug side effect"},{"ID":237,"Name":"Erection problems"},{"ID":181,"Name":"Excessive feeling of fear"},{"ID":11,"Name":"Flu"},{"ID":281,"Name":"Food poisoning"},{"ID":107,"Name":"German measles"},{"ID":104,"Name":"Headache"},{"ID":87,"Name":"Heart attack"},{"ID":434,"Name":"Heart racing"},{"ID":130,"Name":"Hernia"},{"ID":209,"Name":"Huntington's disease"},{"ID":15,"Name":"Hypersensitivity reaction"},{"ID":83,"Name":"Inflammation of the brain covering membranes"},{"ID":235,"Name":"Inflammation of the epididymis"},{"ID":44,"Name":"Inflammation of the nose and throat"},{"ID":504,"Name":"Inflammation of the prostate"},{"ID":331,"Name":"Inflammation of the testes"},{"ID":131,"Name":"Joint infection"},{"ID":324,"Name":"Kidney stones"},{"ID":109,"Name":"Kissing disease"},{"ID":166,"Name":"Listeria infection"},{"ID":51,"Name":"Loose watery stools"},{"ID":79,"Name":"Lyme disease"},{"ID":357,"Name":"Malignant prostate cancer"},{"ID":50,"Name":"Menopause"},{"ID":489,"Name":"Menstrual cramps"},{"ID":347,"Name":"Narrowing of foreskin"},{"ID":167,"Name":"Obstruction of a pulmonary artery"},{"ID":446,"Name":"Pregnancy"},{"ID":18,"Name":"Reflux disease"},{"ID":376,"Name":"Scarlet fever"},{"ID":68,"Name":"Shaking palsy"},{"ID":67,"Name":"Sick headache"},{"ID":103,"Name":"Slipped disc"},{"ID":19,"Name":"Smoking"},{"ID":510,"Name":"Sperm cyst"},{"ID":476,"Name":"Stomach bleeding"},{"ID":488,"Name":"Strain of the back muscles"},{"ID":151,"Name":"Torsion of testes"},{"ID":497,"Name":"Tubal and ovarian inflammation"},{"ID":59,"Name":"Urinary tract infection"}]
		other=[{"ID":11,"Name":"Flu", "Date": "3/22/2016 12:16", "Location": "house"},{"ID":281,"Name":"Food poisoning","Date":"5/12/2016 01:22","Location": "house"}]
		for items in diseases:
			single_disease=items["Name"].lower()
			# print single_disease
			# print conversation
			# print self.find_disease(conversation,single_disease)




			if self.find_disease(conversation,single_disease)!=False:
				new_trip["ID"]=items["ID"]
				new_trip["Name"]=single_disease
				#new_trip["YT"]=yt().aron("string")
#				new_trip["YT"]=yt().aron(new_trip["Name"])
				new_trip["Date"]=time.strftime("%m/%d/%Y %I:%M %p")
				#time.strftime("%d/%m/%Y"))
				other.append(new_trip)
				#print json.dumps(new_trip)
				return json.dumps(new_trip)
		return False
				

		
			

#print get_data().send_json(conversation)
# text="hey"
# print get_data().send_json(text)
# 


