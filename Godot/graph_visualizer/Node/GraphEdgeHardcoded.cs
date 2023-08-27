using Godot;
using System;

/*
Author disclaimer:
This class is done in C# since its constantly being processed.
I would like to do everything in C#, but since Godot has some
limitations when using it, I am trying to write everything in GDscript.
*/

/// <summary>
/// GraphEdge keeps the nodes together and moves the lines when nodes are moved
/// This version is for tutorials, so they are not spawned automatically by the level.
/// </summary>
public class GraphEdgeHardcodedCS : GraphEdgeCS
{
	/// since these are hardcoded edges that are always the same and
	/// are not set by randomness at the beginning of the level, we can
	// set the nodes directly, so the edge is generated at the beginning of the level

	[Export]
	private NodePath nodeA; 

	[Export]
	private NodePath nodeB;

	private int labels_and_positions_with_nodes_executions = 0;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		this.ZIndex = -3;
		SetProcess(false);
		line = GetNode<Line2D>("Line2D");
		collision_line = GetNode<CollisionShape2D>("Area2D/LineCollision");
		clickable_area = (RectangleShape2D) collision_line.Shape;
		shipPath = GetNode<Path2D>("ShipPath");
		shipPathFollow = GetNode<PathFollow2D>("ShipPath/ShipPathFollow");
		shipAnimationPlayer = GetNode<AnimationPlayer>("ShipPath/ShipAnimationPlayer");
		shipSprite = GetNode<Sprite>("ShipPath/ShipPathFollow/Sprite");
		
		// Get the node sfrom the node paths that are hardcoded from the scene and generate
		// an edge between these nodes 
		Node2D node1 = GetNode<Node2D>(nodeA);
		Node2D node2 = GetNode<Node2D>(nodeB);
		this.SetProcess(false);
		set_label_and_positions_with_nodes(node1, node2, "");
	}

	public override void _Process(float delta){}
	
	/// This is called from godot, therefore, it uses snake_case
	new public void set_label_and_positions_with_nodes(Node2D node1, Node2D node2, String label_text)
	{
		// Call the super class method
		// Do not allow this method to be called more than once
		if (labels_and_positions_with_nodes_executions > 0)
		{
			// Print to warn the user
			GD.Print("set_label_and_positions_with_nodes should not be called more than once");
			return;
		}
		base.set_label_and_positions_with_nodes(node1, node2, label_text);
		labels_and_positions_with_nodes_executions += 1;
	}

}





