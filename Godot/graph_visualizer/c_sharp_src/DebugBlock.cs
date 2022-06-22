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
    private PackedScene label_template = (PackedScene)  GD.Load("res://AlgorithmScenes/Code/variable_in_heap_template.tscn");
    private VBoxContainer lines_container;

    private bool mouse_inside_area = false;
    private Godot.Collections.Dictionary<string, Label> labels = new Godot.Collections.Dictionary<string, Label>(); // Info is here
    private Godot.Collections.Dictionary<int, string> map_int_to_name = new Godot.Collections.Dictionary<int, string>();
    private Label current_label = new Label();

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        lines_container = GetNode<VBoxContainer>("LinesContainer");
        GetNode<Resource>("/root/StoredData").Set("debug_block", this);// TODO: If this doesn't work, we can search the node
        // Elsewise, StoredData.singleton.debug_block = this
    }

    public bool has_variable(string var_name){
        return labels.ContainsKey(var_name);
    }

    public void add_variable(string var_name, ADT var_data){
        // TODO: send a message to the Mediator and remove the variable
        Label new_label = (Label) label_template.Instance();
        set_data_to_label(new_label, var_name, var_data);
        lines_container.AddChild(new_label);
    }

    public void delete_variable(string entry){
        // TODO: send a message to the Mediator and remove the variable
        return;
    }

    public void set_data_to_label(Label new_label, string var_name, ADT var_data){
        new_label.Name = "heap_" + var_name as string;
        // new_label.text = str(var_name + " : " + str(var_data.as_string()))
        // self.labels[var_name] = label
        // self.map_int_to_name[self.labels.size() - 1] = var_name
        // label.add_to_group("heap_objects")
        // label.clip_text = true
    }

    // public void update_data_with_dictionary(Godot.Collections.Dictionary<string, ADT> new_data){
    //     // Look into new data and add it when necessary
    //     // If data is already there, update it
    //     foreach (System.Collections.Generic.KeyValuePair<string, ADT> entry in new_data){
    //         if (!has_variable(entry.Key)) {
    //             add_variable(entry.Key, entry.Value);
    //         }
    //         else {
    //             set_data_to_label(
    //                 labels[entry.Key],
    //                 entry.Key,
    //                 new_data[entry.Key]
    //             );
    //         }
    //     }
    //     // There is a case in which the new data has less variables, for example,
    //     // When a variable was recently deleted
    //     // Check variables and erase variables that are not in new data.
    //     foreach (System.Collections.Generic.KeyValuePair<string, ADT> entry in data){
    //         if ( !new_data.ContainsKey(entry.Key) ){
    //             delete_variable(entry.Key);
    //         }
    //     }
    // }


    public void update_model(Godot.Collections.Array<ADTVector> data){
        GD.Print(data);
    }

    public void update_view(int selected_index){
        GD.Print(selected_index);
    }


}
