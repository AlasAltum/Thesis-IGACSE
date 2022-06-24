using Godot;
using System;

public class ADTShower : PanelContainer
{
    public int current_adt;
    private Godot.Collections.Array<ADTRepresentation> representations;  /// These are the children of the current Node

    private void clear_children_and_representations(){
        representations = new Godot.Collections.Array<ADTRepresentation>();
        foreach (Node2D representation_node in representations){
            representation_node.QueueFree();
        }
    }

    public void update_model(Godot.Collections.Array<ADTVector> data) {
        clear_children_and_representations();
        foreach (ADTVector element in data){
            ADTRepresentation curr_representation = element.get_data().get_representation();
            curr_representation.Visible = false;
            this.AddChild(curr_representation);
            representations.Add(curr_representation);
        }
    }

    public void update_view(int selected_index){
        representations[selected_index].Visible = true;
    }

}
