using Godot;
using System;


public class GraphEdge : PinJoint2D
{

    private Label curr_label;
    private Line2D line;
    private CollisionShape2D edge_collision;
    private float weight = 1.0f;
    [Export]
    private Node2D joint_end1;
    [Export]
    private Node2D joint_end2;
    
    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        base._Ready();
        this.SetProcess(false);
        curr_label = GetNode<Label>("Label");
        line = GetNode<Line2D>("Line2D");
        edge_collision = GetNode<CollisionShape2D>("Area2D/LineCollision");
    }

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(float delta)
    {
        line.SetPointPosition(0, joint_end1.Position);
        line.SetPointPosition(1, joint_end2.Position);

        curr_label.SetPosition(
            (joint_end1.Position + joint_end2.Position) / 2
        );
    }

    public void set_label_and_positions_with_nodes(Node2D node1, Node2D node2, String label_text){
    	Vector2[] line_vertices = {node1.Position, node2.Position}; 
        line.Points = line_vertices;
    	curr_label.Text = label_text;
    	this.ZIndex = -1;
        this.SetProcess(true);
        joint_end1 = node1;
        joint_end2 = node2;
        this.NodeA = node1.GetPath();
        this.NodeB = node2.GetPath();
    }


}
