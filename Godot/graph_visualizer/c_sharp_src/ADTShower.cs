using Godot;
using System;

public class ADTShower : PanelContainer
{

    // Called when the node enters the scene tree for the first time.
    // public override void _Ready()
    // {
        
    // }

    public void update_model(Godot.Collections.Array<ADTVector> data){
        GD.Print(data);
    }

    public void update_view(int selected_index){
        GD.Print(selected_index);
    }

}
