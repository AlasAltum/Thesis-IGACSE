using Godot;
using System;

/*
According to the mediator pattern, this class is used 
to regulate interaction between DebugBlock and ADTShower,
so we have only one single source of truth. This class
will update models and views on each change.
Each class will know how to update their views and models using
the
 data given by this class.
*/

public class ADTMediator : Node2D
{
    private Godot.Collections.Array<ADTVector> data;
    private ADTShower adt_shower; // ADTShower class
    private DebugBlock debug_block; // DebugBlock class
    private int selected_index = 0;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        // GetNode<StoredData>("/root/StoredData").adt_mediator = this;
        GetNode<Resource>("/root/StoredData").Set("adt_mediator", this);// TODO: If this doesn't work, we can search the node
    }

    // Initialize structures to work with
    public void set_structures(ADTShower _adt_shower,  DebugBlock _debug_block){
        adt_shower = _adt_shower;
	    debug_block = _debug_block;
    }

    public void update_model(){
	    adt_shower.update_model(data);
	    debug_block.update_model(data);
    }

    public void update_view(){
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
        return get_variable(var_name) == null ? false : true;
    }

}
