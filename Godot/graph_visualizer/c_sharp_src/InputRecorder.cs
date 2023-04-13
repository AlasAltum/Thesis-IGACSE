using Godot;
using System;
using Godot.Collections;


public class InputRecorder : Node
{
	private string DeviceID;
	private const float TIME_BETWEEN_MOUSE_POS_RECORDINGS = 1.5f;
	private float time_since_last_record = 0.0f;
	private const string REQUEST_URL = "https://igasce.azurewebsites.net/api/igasce?code=7x0mMQ-QgCsURHIl_KEPF0sl2MjsH3R4CKttXIsfF8IiAzFuApnNvA=="; // Enter here your API's url


	private HTTPClient RequestHandler;
	private HTTPRequest HTTPRequester;

	private const string KEY_EVENT_ID = "eventid";
	private const string KEY_TIMESTAMP = "timestamp";
	private const string KEY_DEVICE_ID = "deviceid";
	private const string KEY_MOUSE_POS = "mousepos";
	private const string KEY_KEYBOARD_POS = "keyboardpos";
	private const string KEY_IN_TYPE = "intype";


	private Array<Dictionary> Records = new Array<Dictionary>();

	public override void _Ready()
	{
		DeviceID = OS.GetUniqueId();
		HTTPRequester = GetNode<HTTPRequest>("HTTPRequestNode");
	}

	public override void _Process(float delta)
	{
		time_since_last_record += delta;
	}

	public Array<Dictionary> get_records()
	{
		return Records;
	}

	public Error SendRequest(Dictionary Record)
	{
		Node2D StoredData = GetTree().Root.GetNode<Node2D>("/root/StoredData");
		if (StoredData == null || (bool) StoredData.Get("allow_sending_request"))
		{
			return Error.Failed;
		}
		string sent_data = JSON.Print(Record);
		string data_length_as_string = sent_data.Length.ToString();
		if ( !data_length_as_string.StartsWith("[") && !data_length_as_string.EndsWith("]") )
		{
			data_length_as_string = "[" + data_length_as_string + "]";
		}
		string[] headers = {
			"Content-Type: application/json",
			"Content-Length: " + data_length_as_string
		};
		return HTTPRequester.Request(
			url: REQUEST_URL,
			customHeaders: headers,
			sslValidateDomain: false,
			method: HTTPClient.Method.Post,
			requestData: sent_data
		);
	}

	// Call from GDScript
	public void send_requests_with_records()
	{
		foreach (Dictionary Record in Records)
		{
			SendRequest(Record);
		}
	}

	private Godot.Collections.Dictionary GenerateRecord()
	{
		Godot.Collections.Dictionary Record = new Godot.Collections.Dictionary();
		Record[KEY_EVENT_ID] = (OS.GetDatetime().ToString() + DeviceID)?.ToString().SHA256Text();
		Record[KEY_TIMESTAMP] = OS.GetDatetime().ToString();
		Record[KEY_DEVICE_ID] = DeviceID;
		return Record;
	}

	public override void _Input(InputEvent @event)
	{
		// Mouse movements are too many requests and they do not give more information
		//		if (@event is InputEventMouseMotion mouseMotionEvent) // Mouse moving
		//		{
		//			if (time_since_last_record > TIME_BETWEEN_MOUSE_POS_RECORDINGS)
		//			{
		//				Godot.Collections.Dictionary Record = GenerateRecord();
		//
		//				Record[KEY_MOUSE_POS] = mouseMotionEvent.GlobalPosition;
		//				Record[KEY_KEYBOARD_POS] = "";
		//				Record[KEY_IN_TYPE] = "MouseMov";
		//				time_since_last_record = 0.0f; // reset timer
		//				Records.Add(Record);
		//			}
		//		}
		if (@event is InputEventMouseButton clickEvent) // Mouse clicking
		{
			Godot.Collections.Dictionary Record = GenerateRecord();

			Record[KEY_MOUSE_POS] = clickEvent.GlobalPosition;
			Record[KEY_KEYBOARD_POS] = "";
			Record[KEY_IN_TYPE] = "Click";

			Records.Add(Record);
		}
		else if (@event is InputEventKey keyboardEvent && keyboardEvent.Pressed) // keyboard detected
		{
			Godot.Collections.Dictionary Record = GenerateRecord();

			Record[KEY_MOUSE_POS] = "";
			Record[KEY_KEYBOARD_POS] = OS.GetScancodeString(keyboardEvent.Scancode);
			Record[KEY_IN_TYPE] = "KeyPress";

			Records.Add(Record);
		}
	}


	/// This method will tell the database when the player started a new level
	public Error send_new_level_record_as_request(String new_level)
	{
		Godot.Collections.Dictionary Record = new Godot.Collections.Dictionary();
		Record[KEY_EVENT_ID] = (OS.GetDatetime().ToString() + DeviceID)?.ToString().SHA256Text();
		Record[KEY_TIMESTAMP] = OS.GetDatetime();
		Record[KEY_DEVICE_ID] = DeviceID;
		Record[KEY_MOUSE_POS] = "";
		Record[KEY_KEYBOARD_POS] = "";
		Record[KEY_IN_TYPE] = new_level;
		// Send this record, telling the server the player initialized a new level
		return SendRequest(Record);
	}


}
