using Godot;
using System;
using System.Collections.Generic;

/// <summary>
/// Represents a Queue that contains a representation and a collection of elements 
/// </summary>

public class QueueADT : ADT
{

    /// We are not explicting AGraphNode class since it was designed in GDScript
    public Godot.Collections.Array<KinematicBody2D> data = new Godot.Collections.Array<KinematicBody2D>(); /// Uses a GraphNode

    public override string get_type(){
        return "Queue";
    }

    /// Generate string as Queue((0), (1), (2), (3), (4), (5)) for a Queue with nodes [0, 1, 2, 3, 4, 5]
    private string get_data_as_string(){
        string ret = "";
        if (data != null && data.Count > 0){
            for (int i = 0; i < data.Count - 1; i++){
                ret += data[i].ToString(); // TODO: Check if this works cross-code with GDscript
            }
            ret += data[data.Count - 1].ToString(); // TODO: Check
        }
        return ret;
    }

    public override string as_string(){
        return "Queue(" + get_data_as_string() + ")";
    } 

    /// Add a GraphNode to the queue
    public void add_data(KinematicBody2D incoming_node){
        data.Add(incoming_node);
        representation.Call("_add_node", incoming_node); // TODO: Check, maybe we need to call method in other way
    }

    /// Get the first GraphNode from the Queue, take it from the queue and return it
    public KinematicBody2D top(){
        KinematicBody2D ret = data[0];
        representation.Call("_remove_node", ret); // TODO: Check since this is cross language
        data.RemoveAt(0);
        return ret;
    }

    /// This method should be called after the creation of the Queue
    public override void create_representation(){
        representation_path = (PackedScene) GD.Load("res://AlgorithmScenes/Screen/ADT/Queue/QueueRepresentation.tscn");
        representation = (ADTRepresentation) representation_path.Instance();
    }

}
