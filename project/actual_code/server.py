
from twisted.internet import protocol
from twisted.application import service, internet
from twisted.protocols import basic
from twisted.web.client import getPage
from twisted.internet.endpoints import TCP4ServerEndpoint
from twisted.internet import reactor

import client
import conf

import logging
import time
import json
import sys

#	documentation
# https://docs.python.org/2/howto/logging.html
# http://proquest.safaribooksonline.com/book/programming/python/9781449326104
# http://twistedmatrix.com/documents/9.0.0/api/twisted.internet.protocol.Factory.html

URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location={0}&radius={1}&key={2}"

#global dictionary to refer to the relations between different servers
server_relations = {
	"Alford": ["Hamilton", "Welsh"],
	"Hamilton": ["Alford", "Holiday"],
	"Ball": ["Holiday", "Welsh"],
	"Holiday": ["Hamilton", "Ball"],
	"Welsh": ["Alford", "Ball"]
}

class TwistdServer(basic.LineReceiver):
	def __init__(self, factory):
		self.factory = factory
		self.server_name = self.factory.name
		#self.port = conf.PORT_NUM[self.server_name]
		f_name = self.server_name+'.log'
		logging.basicConfig(filename=f_name, level=logging.DEBUG)
		logging.info("Server Created")

	def connectionMade(self):
		logging.info('Client connected to: {0}'.format(self.server_name))

	def updateClientLocation(self, clientName, location, timeReceived):
		timeDiff = time.time() - timeReceived
		timeDiffstr = ""
		if timeDiff > 0:
			timeDiffstr = "+" + str(timeDiff)
		else:
			timeDiffstr = "-" + str(timeDiff)
		msg = "AT {0} {1} {2} {3} {4}\n".format(self.server_name, timeDiffstr,clientName, location, timeReceived)
		self.transport.write(msg)
		if clientName in self.factory.clients:
			# client already exists
			if(self.factory.clients[clientName][0] != location):
				# update in own cache
				self.factory.clients[clientName][0] = location
				self.factory.clients[clientName][1] = self.server_name
				self.factory.clients[clientName][2] = timeDiffstr
				self.factory.clients[clientName][3] = timeReceived
				#send to all neighbors
				#msg = "AT " + str(self.server_name) + " " + str(timeDiff) + " "+ str(clientName) + " " + str(location) + " " + str(timeReceived)
				msg += " " + self.server_name
				factory = client.TwistdClientFactory(msg)
				for s in server_relations[self.server_name]:
					reactor.connectTCP("localhost", conf.PORT_NUM[s], factory)
					logging.info("Message sent from {0} to {1}".format(self.server_name, s))
		else:
			# client doesn't exist so add to cache
			self.factory.clients[clientName] = []
			self.factory.clients[clientName].append(location)
			self.factory.clients[clientName].append(self.server_name)
			self.factory.clients[clientName].append(timeDiffstr)
			self.factory.clients[clientName].append(timeReceived)
			#msg = "AT " + str(self.server_name) + " " + str(timeDiff) + " "+ str(clientName) + " " + str(location) + " " + str(timeReceived)
			factory = client.TwistdClientFactory(msg)
			for s in server_relations[self.server_name]:
				reactor.connectTCP("localhost", conf.PORT_NUM[s], factory)
				logging.info("Message sent from {0} to {1}".format(self.server_name, s))

	def formatLocation(self, location):
		sign = "+"
		if "-" in location[1:]:
			sign = "-"
		pos = location[1:].index(sign) + 1
		retString = location[0:pos] + "," + location[pos:]
		retString.replace("+", "")
		return retString

	def findAtLocation(self, clientName, radius, resultBound):
		try:
			clientInfo = self.factory.clients[clientName]
			#location = self.formatLocation(self.factory.clients[clientName][0])
			location = self.formatLocation(clientInfo[0])
			page = getPage(URL.format(location,radius,conf.API_KEY))
			#logging.info("Radius: {}, Result Bount: {}".format(radius, resultBound))
			#logging.info("URL: " + URL.format(location,radius,conf.API_KEY))
			message = "AT {} {} {} {} {}".format(clientInfo[1],clientInfo[2], clientName,clientInfo[0],clientInfo[3])
			page.addCallback(self.handleData, resultBound, message) 
			page.addErrback(self.handleError, URL.format(location,radius,conf.API_KEY))
			logging.info("API Request Completed")
		except KeyError:
			logging.warning("Client Not Found")
			self.transport.write("? WHATSAT {0} {1} {2}\n".format(clientName, radius, resultBound))

	def receiveFromNeighborServer(self, serverName, timeDiff, clientName, location, timeReceived):
		logging.info("Info received from neighboring server about client: {}".format(clientName))
		msg = "AT {0} {1} {2} {3} {4}\n".format(serverName, timeDiff,clientName, location, timeReceived)
		if clientName in self.factory.clients:
			# client already exists
			if(self.factory.clients[clientName][0] != location):
				# update in own cache
				self.factory.clients[clientName][0] = location
				self.factory.clients[clientName][1] = serverName
				self.factory.clients[clientName][2] = timeDiff
				self.factory.clients[clientName][3] = timeReceived
				#send to all neighbors
				#msg = "AT " + str(self.server_name) + " " + str(timeDiff) + " "+ str(clientName) + " " + str(location) + " " + str(timeReceived)
				factory = client.TwistdClientFactory(msg)
				for s in server_relations[self.server_name]:
					reactor.connectTCP("localhost", conf.PORT_NUM[s], factory)
					logging.info("Message sent from {0} to {1}".format(self.server_name, s))
		else:
			# client doesn't exist so add to cache
			self.factory.clients[clientName] = []
			self.factory.clients[clientName].append(location)
			self.factory.clients[clientName].append(serverName)
			self.factory.clients[clientName].append(timeDiff)
			self.factory.clients[clientName].append(timeReceived)
			#msg = "AT " + str(self.server_name) + " " + str(timeDiff) + " "+ str(clientName) + " " + str(location) + " " + str(timeReceived)
			factory = client.TwistdClientFactory(msg)
			for s in server_relations[self.server_name]:
				reactor.connectTCP("localhost", conf.PORT_NUM[s], factory)
				logging.info("Message sent from {0} to {1}".format(self.server_name, s))

		

	def lineReceived(self, line):
		try:	
			inp = line.split(' ')
			if(inp[0] == 'WHATSAT'):
				if int(inp[2]) > 50 or int(inp[3]) > 20:
					self.transport.write('? {}\n'.format(line))
				else:
					self.findAtLocation(inp[1], int(inp[2]), int(inp[3]))
			elif(inp[0] == 'IAMAT'):
				self.updateClientLocation(inp[1], inp[2],float(inp[3]))
			elif(inp[0] == 'AT'):
				#logging.info('Message received from neighboring server: {}'.format(inp[6]))
				inp[5] = inp[5][:-1] # remove the newline character
				self.receiveFromNeighborServer(inp[1], inp[2], inp[3], inp[4], float(inp[5]))
			else:
				self.transport.write('? {0}\n'.format(line))
		except:
			self.transport.write('? {}\n'.format(line))

	def handleData(self, data, limit, message):
		# modify the data object using the json library
		# self.transport.write(str(data) + "\n")
		data_json = json.loads(data)
		# get only the number of results required
		limit_results = data_json["results"][0:limit]
		data_json["results"] = limit_results
		# pretty printing of json from example at https://docs.python.org/2/library/json.html
		self.transport.write("{}\n{}\n\n".format(message, json.dumps(data_json, sort_keys=True,indent=4,separators=(',', ': '))))
		logging.info("API Request Callback Executed")

	def handleError(self, error, url):
		logging.error("Error in accessing API: URL: {} : reason: {}".format(url, error))

	def connectionLost(self, reason):
		logging.info('Client Lost')


class TwistdServerFactory(protocol.Factory):
	def __init__(self, name):
		self.name = name
		self.clients = {}


	def buildProtocol(self, addr):
		return TwistdServer(self)

	def stopFactory(self):
		logging.info("Server {0} shutdown!".format(self.name))


def main():
	if(len(sys.argv) < 2):
		print("Not enough arguments\n")
		return
	#endpoint = TCP4ServerEndpoint(reactor, server_names_to_port[sys.argv[1]])
	#endpoint.listen(TwistdServerFactory(sys.argv[1]))
	reactor.listenTCP(conf.PORT_NUM[sys.argv[1]], TwistdServerFactory(sys.argv[1]))
	reactor.run()

if __name__ == '__main__':
	main()