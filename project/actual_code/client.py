from twisted.internet import protocol
from twisted.protocols import basic


class TwistdClient(basic.LineReceiver):
	def __init__(self, factory):
		self.factory = factory
		self.message = self.factory.message

	def connectionMade(self):
		self.sendLine(self.message)
		self.transport.loseConnection()


class TwistdClientFactory(protocol.ClientFactory):
	def __init__(self, message):
		self.message = message

	def buildProtocol(self, addr):
		return TwistdClient(self)