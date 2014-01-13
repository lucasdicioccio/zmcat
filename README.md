# ZMCat
A simple command tool to test ZMQ pub-sub and push-pull sockets.

# Examples

	zmcat pub tcp://*:5555
	zmcat sub tcp://localhost:5555

	zmcat pub tcp://*:5555 mykey
	zmcat sub tcp://localhost:5555 mykey

	zmcat push tcp://localhost:5555
	zmcat pull tcp://*:5555
	
# Contributions

Gísli Kristjánsson (gislik): multipart messages
