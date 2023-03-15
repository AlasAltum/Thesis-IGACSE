class_name DataServer
extends Resource

# Deprecated class, we are using the InputRecorder.cs instead
# This may be used for debugging though, since C# may have problems with the API

var HTTP = HTTPClient.new()
const url = "http://127.0.0.1:8080/godotevent"

var http_request: HTTPRequest

func set_http_request(_http_request):
	self.http_request = _http_request


func send_data(data: Dictionary):
	http_request
	pass


## TODO: Add this to a thread
#func send_data(data: Dictionary):
#	var RESPONSE = HTTP.connect_to_host("127.0.0.1", 8080)
#	while (
#		HTTP.get_status() == HTTPClient.STATUS_CONNECTING or 
#		HTTP.get_status() == HTTPClient.STATUS_RESOLVING
#	):
#		HTTP.poll()
#		OS.delay_msec(300)
#
##	assert(HTTP.get_status() == HTTPClient.STATUS_CONNECTED)
#
##	var data_as_json = JSON.parse(data)
##	var QUERY = HTTP.query_string_from_dict(data_as_json)
##	var QUERY = JSON.print(data) # HTTP.query_string_from_dict(data_as_json)
#
#	var QUERY = str(data)
#	var HEADERS = [
#		"User-Agent: Godot",
#		"Content-Type: application/json",
#		"Content-Length: " + str(len(data))
#	]
#	RESPONSE = HTTP.request(HTTPClient.METHOD_POST, url, HEADERS, QUERY)
##	assert(RESPONSE == OK)
#	if RESPONSE:
#		while (HTTP.get_status() == HTTPClient.STATUS_REQUESTING):
#			HTTP.poll()
#			OS.delay_msec(300)
#			# Make sure request finishe
#	#	assert(HTTP.get_status() == HTTPClient.STATUS_BODY or HTTP.get_status() == HTTPClient.STATUS_CONNECTED)

