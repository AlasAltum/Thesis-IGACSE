using Godot;
using System;

public class ADTVector : Resource
{
    private string name;
    private ADT data;
    private int index;

    public void set_properties(string _name, ADT _data, int _index){
        name = _name;
        data = _data;
        index = _index;
    }

    public string get_name()
    {
        return name;
    }

    public ADT get_data(){
        return data;
    }

    public ADTRepresentation get_data_representation(){
        return data.representation;
    }
    public void set_data(ADT _data){
        data = _data;
    }

}
