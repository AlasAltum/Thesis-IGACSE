using Godot;
using System;

public abstract class ADT : Resource
{
    protected PackedScene representation_path;
    public ADTRepresentation representation;

    public abstract void create_representation();
    public abstract string as_string();
    public abstract string get_type();

    public ADT get_object(){
        return this;
    }
    

}
