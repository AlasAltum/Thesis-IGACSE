using Godot;
using System;

public abstract class ADTRepresentation : Node2D
{
    public abstract void add_node(Node2D node);
    public abstract void remove_node(Node2D node);
    public abstract void set_properties();
    public Vector2 get_initial_position(){
        return new Vector2(50.0f, 10.0f);
    }

}
