class_name DataServer
extends Resource

var HTTP = HTTPClient.new()
const url = "http://127.0.0.1/"
var RESPONSE = HTTP.connect_to_host("127.0.0.1", 80)

# TODO: Add this to a thread
func send_data(data: Dictionary):
	while (
		HTTP.get_status() == HTTPClient.STATUS_CONNECTING or 
		HTTP.get_status() == HTTPClient.STATUS_RESOLVING
	):
		HTTP.poll()
		OS.delay_msec(300)

#	assert(HTTP.get_status() == HTTPClient.STATUS_CONNECTED)

	var data_as_json = JSON.parse(str(data))

	var QUERY = JSON.print(data) # HTTP.query_string_from_dict(data_as_json)
	var HEADERS = [
		"User-Agent: Godot",
		"Content-Type: application/json",
		"Content-Length: " + str( len(JSON.print(data)) )
	]
	RESPONSE = HTTP.request(HTTPClient.METHOD_POST, url, HEADERS, QUERY)
#	assert(RESPONSE == OK)
	if RESPONSE:
		while (HTTP.get_status() == HTTPClient.STATUS_REQUESTING):
			HTTP.poll()
			OS.delay_msec(300)
			# Make sure request finisheds
	#	assert(HTTP.get_status() == HTTPClient.STATUS_BODY or HTTP.get_status() == HTTPClient.STATUS_CONNECTED)
