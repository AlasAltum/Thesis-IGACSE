using Godot;
using System;
using Godot.Collections;


public class InputRecorder : Node
{
    private string DeviceID;
    private const float TIME_BETWEEN_MOUSE_POS_RECORDINGS = 1.5f;
    private float time_since_last_record = 0.0f;
    private const string REQUEST_URL = ""; // Enter here your API

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

    public void send_requests_with_records()
    {
        HTTPRequest RequestManager = new HTTPRequest();
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
        Record["EventID"] = (OS.GetDatetime().ToString() + DeviceID)?.ToString().SHA256Text();
        Record["Timestamp"] = OS.GetDatetime();
        Record["DeviceID"] = DeviceID;
        return Record;
    }

    public override void _Input(InputEvent @event)
    {
        if (@event is InputEventMouseMotion mouseMotionEvent) // Mouse moving
        {
            if (time_since_last_record > TIME_BETWEEN_MOUSE_POS_RECORDINGS)
            {
                Godot.Collections.Dictionary Record = GenerateRecord();

                Record["MousePos"] = mouseMotionEvent.GlobalPosition;
                Record["KeyboardPos"] = "";
                Record["type"] = "MouseMov";
                time_since_last_record = 0.0f; // reset timer
                Records.Add(Record);
            }
        }
        else if (@event is InputEventMouseButton clickEvent) // Mouse clicking
        {
            Godot.Collections.Dictionary Record = GenerateRecord();

            Record["MousePos"] = clickEvent.GlobalPosition;
            Record["KeyboardPos"] = "";
            Record["type"] = "Click";

            Records.Add(Record);
        }
        else if (@event is InputEventKey keyboardEvent) // keyboard detected
        {
            if (keyboardEvent.Pressed)
            {
                Godot.Collections.Dictionary Record = GenerateRecord();

                Record["MousePos"] = "";
                Record["KeyboardPos"] = OS.GetScancodeString(keyboardEvent.Scancode);
                Record["type"] = "KeyPress";

                Records.Add(Record);
            }
        }
    }


}
