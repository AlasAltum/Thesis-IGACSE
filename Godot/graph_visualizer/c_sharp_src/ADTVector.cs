using Godot;
using System;

public class ADTVector : Resource
{
    private string name;
    private ADT data;

    public void init(string _name, ADT _data){
        name = _name;
        data = _data;
    }

    public string get_name(){
        return name;
    }
    
    public ADT get_data(){
        return data;
    }

}
