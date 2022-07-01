using Godot;
using System;

public class ADTShower : PanelContainer
{
    public int current_adt;
    private Godot.Collections.Array<ADTRepresentation> representations = new Godot.Collections.Array<ADTRepresentation>();  /// These are the children of the current Node

    private void clear_children_and_representations(){
        foreach (Node2D representation_node in representations){
            representation_node.QueueFree();
        }
        representations = new Godot.Collections.Array<ADTRepresentation>();
    }

    public void update_model(Godot.Collections.Array<ADTVector> data) {
        clear_children_and_representations();
        foreach (ADTVector element in data){
            ADTRepresentation curr_representation = (ADTRepresentation) element.get_data().Get("representation");
            curr_representation.Visible = false;
            this.AddChild(curr_representation);
            representations.Add(curr_representation);
        }
    }

    public void update_view(int selected_index){
        representations[selected_index].Visible = true;
    }

}
