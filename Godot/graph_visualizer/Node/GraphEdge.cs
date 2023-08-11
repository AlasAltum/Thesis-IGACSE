using Godot;
using System;

/*
Author disclaimer:
This class is done in C# since its constantly being processed.
I would like to do everything in C#, but since Godot has some
limitations when using it, I am trying to write everything in GDscript.
*/
/*
GraphEdge keeps the nodes together and moves the lines when nodes are moved
*/
public class GraphEdge : PinJoint2D
{

	protected Label curr_label;
	protected Line2D line;
	protected CollisionShape2D collision_line;

	protected static Resource adt = GD.Load("res://AlgorithmScenes/Code/ADTs/edge_adt.gd");
	
	protected static Material HighlightedMaterial = GD.Load<Material>("res://Assets/custom_shaders/edge_hightlight_material.tres");

	// The path the ship will follow, the curve is what interests us
	// Set the curve positions at nodeA and nodeB
	protected Path2D shipPath;

 	// The points in which the ship is going to move, here we manipulat ethe offset
	// through the shipAnimation
	protected PathFollow2D shipPathFollow;

	protected AnimationPlayer shipAnimationPlayer;
	protected Node2D destinationNode;


	[Export]
	protected RectangleShape2D clickable_area;
	
	[Export]
	protected float weight = 1.0f;
	
	[Export]
	protected bool is_selected = false;
	[Export]
	protected Node2D joint_end1;
	[Export]
	protected Node2D joint_end2;
	[Export]
	protected Sprite shipSprite;


	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		base._Ready();
		this.ZIndex = -3;
		SetProcess(false);
		curr_label = GetNode<Label>("Label");
		line = GetNode<Line2D>("Line2D");
		collision_line = GetNode<CollisionShape2D>("Area2D/LineCollision");
		clickable_area = (RectangleShape2D) collision_line.Shape;
		shipPath = GetNode<Path2D>("ShipPath");
		shipPathFollow = GetNode<PathFollow2D>("ShipPath/ShipPathFollow");
		shipAnimationPlayer = GetNode<AnimationPlayer>("ShipPath/ShipAnimationPlayer");
		shipSprite = GetNode<Sprite>("ShipPath/ShipPathFollow/Sprite");
	}

	public override void _Process(float delta)
	{
		line.SetPointPosition(0, joint_end1.GlobalPosition);
		line.SetPointPosition(1, joint_end2.GlobalPosition);

		curr_label.SetPosition(
			(joint_end1.GlobalPosition + joint_end2.GlobalPosition) / 2
		);
		set_collision_box();

	}

	protected bool valueIsCloseTo(float value1, float value2, float tolerance)
	{
		return Godot.Mathf.Abs(value1 - value2) < tolerance;
	}

	protected float RadiansToDegrees(float angle)
	{
		return angle * 180 / Mathf.Pi;
	}

	/// Make sure Labels are not that much rotated so they are always readable
	// Rotation is coming in radians
	protected float normalizeRotation(float rotation)
	{
		// Make 90° labels vertical by not rotating them 
		if ( valueIsCloseTo(rotation, Mathf.Pi/2, 0.05f) || valueIsCloseTo(rotation, -Mathf.Pi/2, 0.05f) || valueIsCloseTo(rotation, Mathf.Pi, 0.05f) )
		{
			return 0.0f;
		}
		// Turn label until rotation is between [-90°, 90°] degrees
		while (Godot.Mathf.Abs(RadiansToDegrees(rotation)) > 90.0f )
		{
			if (RadiansToDegrees(rotation) > 90.0f)
			{
				rotation = rotation - Mathf.Pi;
			}
			// lower than -150 degrees => 30 degrees
			else if (RadiansToDegrees(rotation) < -90.0f)
			{
				rotation = rotation + Mathf.Pi;
			}
		}
		return rotation;
	}

	/// This is called from godot, therefore, it uses snake_case
	public void set_label_and_positions_with_nodes(Node2D node1, Node2D node2, String label_text){
		Vector2[] line_vertices = {node1.GlobalPosition, node2.GlobalPosition}; 
		line.Points = line_vertices;
		if (label_text != "") 
		{
			curr_label.Text = label_text;
			this.weight = float.Parse(label_text); // we prefer to receive a string and turn it into a float
			Vector2 node1_pos = (Godot.Vector2) node1.Get("aux_position");
			Vector2 node2_pos = (Godot.Vector2) node2.Get("aux_position");
			Vector2 difference = node2_pos - node1_pos;
			float rotation = Godot.Mathf.Atan2( (float) difference.y, (float) difference.x);
			rotation = normalizeRotation(rotation);
			curr_label.SetRotation(rotation);
		}
		// This is requested when we allow graph movement
		this.SetProcess(true);
		joint_end1 = node1;
		joint_end2 = node2;
		this.NodeA = node1.GetPath();
		this.NodeB = node2.GetPath();
		set_collision_box();

	}

	public Node2D getJointEnd1() => joint_end1;

	public Node2D getJointEnd2() => joint_end2;

	/// <summary>
	/// To set this quad, we will set the extent of the rectangle like the following
	/// extent(x, y) := y will be its margin, x will be its distance
	///	position(x, y) := (node1.position + node2.position) / 2
	///	rotation(alpha) := arctan( (node2.y - node1.y) / (node2.x - node1.x) )
	/// </summary>
	protected void set_collision_box()
	{
		// Set extent of the collision box for the line
		Vector2 pos1 = (Vector2) joint_end1.GlobalPosition;
		Vector2 pos2 = (Vector2) joint_end2.GlobalPosition;

		float distance = Mathf.Sqrt(
			(pos2.y - pos1.y) * (pos2.y - pos1.y) + (pos2.x - pos1.x) * (pos2.x - pos1.x)
		) - 60.0f;
		clickable_area.Extents = new Vector2(distance * 0.5f, 8.0f);
		// Set the position of the collision box
		collision_line.GlobalPosition = (pos1 + pos2) * 0.5f;
		collision_line.Rotation = Mathf.Atan2(pos2.y - pos1.y, pos2.x - pos1.x);
	}

	public void _on_Area2D_input_event(Viewport viewport, InputEvent @event, int shape_idx) { 
		if (@event is InputEventMouseButton btn && 
			btn.ButtonIndex == (int) ButtonList.Left && @event.IsPressed()) 
		{
			Node mainNode =  GetNode("/root/Main"); // Note: There is no MainNode in tutorials
			if (mainNode is null)  // therefore, this action does not matter during tutorials
			{
				return;
			}

			bool are_nodes_clickable = (bool) mainNode.Get("allow_edge_selection");
			if (are_nodes_clickable) {
				_on_edge_click();
			}

		}
	}

	/// <summary>
	/// Intended to be used for Kruskal and Prim, to order edges
	/// </summary>
	protected void _on_edge_click() {
		Node StoredData = GetNode("/root/StoredData");
		StoredData.Set("selected_edge", this);
	}

	public Resource get_adt() => GraphEdge.adt;

	public String get_class() => "GraphEdge";

	public String as_string(){
		return "Edge (" + joint_end1.Get("index") + "-" + joint_end2.Get("index") + ")";
	}

	public Node2D[] get_connecting_nodes(){ 
		return new []{joint_end1, joint_end2};
	}

	public void set_selected(){
		this.is_selected = true;
		this.Modulate = new Color(1.0f, 0.0f, 0.0f);
	}

	public void set_weight_visible(bool visible_weight){
		curr_label.Visible = visible_weight;
	}

	public bool is_not_selected() => !this.is_selected;

	public void set_is_highlighted(bool set_is_highlighted)
	{
		if (set_is_highlighted)
		{
			this.Material = HighlightedMaterial;
		}
		else 
		{
			this.Material = null;
		}
	}

	/// Used to set the edge as explored. An edge is considered explored when its two connecting nodes
	/// have been explored
	public void set_edge_transparency_as_explored()
	{
		this.SelfModulate = new Color(1.0f, 1.0f, 1.0f, 70/255f);
	}

	public void send_ship_from_nodeA_to_nodeB(Node2D nodeA, Node2D nodeB)
	{
		// turn on animation to send the ship from nodeA to nodeB
 		shipPathFollow.UnitOffset = 0;

		Curve2D path = shipPath.Curve;
		path.ClearPoints();
		path.AddPoint(nodeA.GlobalPosition);
		path.AddPoint(nodeB.GlobalPosition);
		destinationNode = nodeB;
		Animation shipTravelAnimation = shipAnimationPlayer.GetAnimation("ShipTravel");
		shipTravelAnimation.Loop = false;

		shipAnimationPlayer.Play("ShipTravel");
	}

	public bool edge_connects_nodes_u_and_v(Node u, Node v){
		if ((this.joint_end1 == u && this.joint_end2 == v) || (this.joint_end1 == v && this.joint_end2 == u))
		{
			return true;
		}
		return false;
	}

	protected void _on_ShipAnimationPlayer_animation_finished(String anim_name)
	{
		NotifiyNodeBToPlayStationAnimation();
	}

	// Once the ship arrives at node B, we want to notify the node to play its animation
	// of the station being built and the ship being flying around it
	public void NotifiyNodeBToPlayStationAnimation()
	{
		if (destinationNode != null)
			destinationNode.Call("on_ship_arrived");
	}
}





