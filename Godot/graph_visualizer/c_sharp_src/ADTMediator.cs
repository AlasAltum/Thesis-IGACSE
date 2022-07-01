using Godot;
using System;

/*
According to the mediator pattern, this class is used 
to regulate interaction between DebugBlock and ADTShower,
so we have only one single source of truth. This class
will update models and views on each change.
Each class will know how to update their views and models using
the data given by this class.
*/

public class ADTMediator : Node2D
{
    private Godot.Collections.Array<ADTVector> data = new Godot.Collections.Array<ADTVector>();
    private ADTShower adt_shower; // ADTShower class
    private DebugBlock debug_block; // DebugBlock class
    private int selected_index = 0;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        GetNode<Node2D>("/root/StoredData").Set("adt_mediator", this);// TODO: If this doesn't work, we can search the node
        debug_block = GetNode<DebugBlock>("/root/Main/CanvasLayer/LeftPanel/DebugBlock");// TODO: If this doesn't work, we can search the node
        adt_shower = GetNode<ADTShower>("/root/Main/CanvasLayer/LeftPanel/ADTShower");// TODO: If this doesn't work, we can search the node
    }

    // Initialize structures to work with. This method should be called after initialization
    public void initialize(ADTShower _adt_shower,  DebugBlock _debug_block){
        adt_shower = _adt_shower;
	    debug_block = _debug_block;
    }

    /// Adds or update a variable using its name. If the variable exists, it is updated
    public void add_variable(string var_name, ADT incoming_data){
        if ( !has_variable(var_name) ) {
            int test = data.Count;
            ADTVector new_data = new ADTVector();
            new_data.set_properties(var_name, incoming_data, test);
            data.Add(new_data);
        } else {
            update_variable_data(var_name, incoming_data);
        }
        update_models();
        update_views();
    }

    public void update_variable_data(string var_name, ADT data){
        ADTVector current_variable = get_variable(var_name);
        current_variable.set_data(data);
        update_models();
        update_views();
    }

    /// Updates data in associated structures. Should be called before update views
    public void update_models(){
	    adt_shower.update_model(data);
	    debug_block.update_model(data);
    }

    /// Updates visual data in associated structures. Should be called after update models
    public void update_views(){
	    adt_shower.update_view(selected_index);
	    debug_block.update_view(selected_index);
    }

    public ADTVector get_variable(String var_name){
        foreach (ADTVector vector in data) {
            if (vector.get_name() == var_name){
                return vector;
            }
        }
        return null;
    }

    public bool has_variable(String var_name){
        return (get_variable(var_name) != null);
    }

}
