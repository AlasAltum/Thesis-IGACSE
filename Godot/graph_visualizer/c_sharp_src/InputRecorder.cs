using Godot;
using System;
using Godot.Collections;


public class InputRecorder : Node
{
	private string DeviceID;
	private const float TIME_BETWEEN_MOUSE_POS_RECORDINGS = 1.5f;
	private float time_since_last_record = 0.0f;
	private const string REQUEST_URL = ""; // Enter here your API

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
	}
	public override void _Process(float delta)
	{
		time_since_last_record += delta;
	}

	public Array<Dictionary> get_records()
	{
		return Records;
	}

	// Call from GDScript
	public void send_requests_with_records()
	{
		HTTPRequest RequestManager = new HTTPRequest();
		// TODO: Send all of these records in just one big record
		foreach (Dictionary Record in Records)
		{
			string sent_data = JSON.Print(Record);
			RequestManager.Request(
				url: REQUEST_URL,
				customHeaders: null,
				sslValidateDomain: false,
				method: HTTPClient.Method.Post, 
				requestData: sent_data
			);
		}
		//         //   customHeaders:
		// //     If the parameter is null, then the default value is Array.Empty<string>()
		// [GodotMethodAttribute("request")]
		// public Error Request(string url, string[] customHeaders = null, bool sslValidateDomain = true, HTTPClient.Method method = HTTPClient.Method.Get, string requestData = "");
		// //
	}

	private Godot.Collections.Dictionary GenerateRecord()
	{
		Godot.Collections.Dictionary Record = new Godot.Collections.Dictionary();
		Record[KEY_EVENT_ID] = (OS.GetDatetime().ToString() + DeviceID)?.ToString().SHA256Text();
		Record[KEY_TIMESTAMP] = OS.GetDatetime();
		Record[KEY_DEVICE_ID] = DeviceID;
		return Record;
	}

	public override void _Input(InputEvent @event)
	{
		if (@event is InputEventMouseMotion mouseMotionEvent) // Mouse moving
		{
			if (time_since_last_record > TIME_BETWEEN_MOUSE_POS_RECORDINGS)
			{
				Godot.Collections.Dictionary Record = GenerateRecord();

				Record[KEY_MOUSE_POS] = mouseMotionEvent.GlobalPosition;
				Record[KEY_KEYBOARD_POS] = "";
				Record[KEY_IN_TYPE] = "MouseMov";
				time_since_last_record = 0.0f; // reset timer
				Records.Add(Record);
			}
		}
		else if (@event is InputEventMouseButton clickEvent) // Mouse clicking
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


}
