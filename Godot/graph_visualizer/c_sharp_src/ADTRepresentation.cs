using Godot;
using System;

public abstract class ADTRepresentation : Node2D
{
    public Vector2 get_initial_position => new Vector2(50.0f, 10.0f);

    public abstract void add_node(KinematicBody2D node);
    public abstract void remove_node(KinematicBody2D node);
    //public abstract void set_properties();

}
