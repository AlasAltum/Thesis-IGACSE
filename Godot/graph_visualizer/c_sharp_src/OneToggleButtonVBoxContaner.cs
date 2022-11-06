using Godot;
using System;
using System.Linq; // Import the C# collection query api


public class OneToggleButtonVBoxContaner : VBoxContainer
{

	private Godot.Collections.Array<Button> toggle_buttons;

	private void ToggleButton(Button incoming_button)
	{
		foreach (Button child_button in toggle_buttons){
			if (child_button == incoming_button)
			{
				incoming_button.Pressed = true;
				
			} else {
				child_button.Pressed = false;
			}
		}

	}

	public override void _Ready()
	{
		var mapped_buttons = GetChildren().Cast<Button>();
		
		toggle_buttons = new Godot.Collections.Array<Button>();

		foreach (var button in mapped_buttons)
		{
			toggle_buttons.Add(button);
			button.Connect("pressed", this, "ToggleButton", new Godot.Collections.Array { button });
		}
		GD.Print(toggle_buttons);
	}

}
