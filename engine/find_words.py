

class get_data():
	def __init__(self):
		print "created get_data object"

	def find_disease(self,conversation,condition):		
		if conversation.find(condition):
			return condition

	def find_medicine(self,conversation,medication):
		if conversation.find(medication):
			return medication

conversation= """Hello Russell How are you? Bla Bla Bla. From your symptoms it seems like 
you have strep throat. I prescribe amoxicilin"""

print get_data().find_disease(conversation,"strep throat")
print get_data().find_disease(conversation,"amoxicilin")

