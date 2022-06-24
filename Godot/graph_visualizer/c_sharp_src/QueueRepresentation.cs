using Godot;
using System;

public class QueueRepresentation : ADTRepresentation
{
    private PackedScene node_label_prefab = (PackedScene) GD.Load("res://AlgorithmScenes/Screen/ADT/NodeInADT.tscn");
    private VBoxContainer nodes_vbox;
    private Godot.Collections.Dictionary<int, Label> labels_indexes = new Godot.Collections.Dictionary<int, Label>();

    public override void _Ready()
    {
        nodes_vbox = GetNode<VBoxContainer>("NodesVBox");
    }

    // Add node to QueueRepresentation
    public override void add_node(KinematicBody2D node){
        Label new_label = (Label) node_label_prefab.Instance();
        int node_index = (int) node.Call("get_index");
        new_label.Text = node_index.ToString(); // TODO: Check for cross language
        new_label.Name = "NodeInQueue" + node_index.ToString();
        labels_indexes[node_index] = new_label;
        nodes_vbox.AddChild(new_label);
        nodes_vbox.MoveChild(new_label, 0); // This produces a reverse order in view
    }

    // Remove node from QueueRepresentation
    public override void remove_node(KinematicBody2D node){
        int node_index = (int) node.Call("get_index");
        Label child_to_remove = labels_indexes[node_index];
        child_to_remove.QueueFree();
    }

}
