using Godot;
using System;
using Godot.Collections;


/// <summary>
/// This class contains displays the current variables on the top left corner of the screen.
/// It shows the current variables in stack and their values. 
/// </summary>

//namespace Godot.Collections; //would be better, but we don't have C# > 10.0

public class DebugBlock : ScrollContainer
{
    private StyleBox focused_style = (StyleBox) GD.Load("res://AlgorithmScenes/Screen/DebugBlock/focus_line_stylebox.stylebox");
    private StyleBox unfocused_style = (StyleBox) GD.Load("res://AlgorithmScenes/Screen/DebugBlock/unfocus_line_stylebox.stylebox");
    private Material focused_material = (Material) GD.Load("res://AlgorithmScenes/Screen/DebugBlock/debug_block_line_focus.material");
    private PackedScene label_template; // = ResourceLoader<PackedScene>.Load("res://AlgorithmScenes/Code/variable_in_heap_template.tscn");
    private VBoxContainer lines_container;

    private bool mouse_inside_area = false;
    private Godot.Collections.Dictionary<string, Label> names_to_labels = new Godot.Collections.Dictionary<string, Label>(); // Info is here
    private Godot.Collections.Dictionary<int, string> map_int_to_name = new Godot.Collections.Dictionary<int, string>();

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        lines_container = GetNode<VBoxContainer>("LinesContainer");
        GetNode<Node2D>("/root/StoredData").Set("debug_block", this);// TODO: If this doesn't work, we can search the node

        // Elsewise, StoredData.singleton.debug_block = this
    }

    public bool has_variable(string var_name){
        return names_to_labels.ContainsKey(var_name);
    }

    public void delete_variable(string entry){
        // TODO: send a message to the Mediator and remove the variable
        return;
    }

    private void add_variable(string var_name, ADT var_data){
        label_template = (PackedScene) ResourceLoader.Load("res://AlgorithmScenes/Code/variable_in_heap_template.tscn");
        Label new_label = (Label) label_template.Instance();
        new_label.Text = var_data.as_string();
        new_label.Visible = false;
        new_label.AddToGroup("heap_objects");
        new_label.ClipText = true;
        names_to_labels[var_name] = new_label;
        map_int_to_name[names_to_labels.Count - 1] = var_name;
    }

    public void update_model(Godot.Collections.Array<ADTVector> data){
        names_to_labels.Clear();
        foreach (ADTVector variable in data){
            string variable_name = variable.get_name();
            ADT variable_data = variable.get_data();
            add_variable(variable_name, variable_data);
        }
    }

    public void update_view(int selected_index){
        names_to_labels[map_int_to_name[selected_index]].Visible = true;
    }


}
