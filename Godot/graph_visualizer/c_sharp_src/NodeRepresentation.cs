using Godot;
using System;

public class NodeRepresentation : ADTRepresentation
{
    private int index = 0;
    private Label NodeName;
    static private Color selected_self_color = new Color(1.0f, 1.0f, 0.0f, 0.8f);
    static private Color selected_node_name_color = new Color(0.0f, 1.0f, 0.0f, 1.0f);
    static private Color unselected_self_color = new Color(1.0f, 1.0f, 1.0f, 1.0f);
    static private Color unselected_node_name_color = new Color(1.0f, 1.0f, 1.0f, 1.0f);

    public Vector2 _initial_position => new Vector2(50.0f, 20.0f);

    // Called when the node enters the scene tree for the first time.
    public override void _Ready() {
        // For some reason, this doesn't work
        // NodeName = (Godot.Label) GetNode("Sprite/NodeName");
    }

    public void set_index(int _index) {
        index = _index;
        if (NodeName == null){
            NodeName = (Godot.Label) GetNode("Sprite/NodeName");
        }
        NodeName.Text = _index.ToString();
    }

    public void set_selected() {
        this.Modulate = new Color(1.0f, 1.0f, 0.0f, 0.8f);
        NodeName.Modulate = new Color(0.0f, 1.0f, 0.0f, 1.0f);
    }

    public void set_unselected() {
        this.Modulate = new Color(1.0f, 1.0f, 0.0f, 0.8f);
        NodeName.Modulate = new Color(0.0f, 1.0f, 0.0f, 1.0f);
    }

    /// A node reprsentation may not receive another node
    public override void add_node(KinematicBody2D node) {
        throw new NotImplementedException();
    }

    /// A node reprsentation may not remove another node
    public override void remove_node(KinematicBody2D node) {
        throw new NotImplementedException();
    }


    //public override void set_properties()
    //{
    //    this.Visible = false;
    //}

}
