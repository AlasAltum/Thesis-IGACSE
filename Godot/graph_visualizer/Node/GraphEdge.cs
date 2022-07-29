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

	private Label curr_label;
	private Line2D line;
	private CollisionShape2D collision_line;

	private static Resource adt = GD.Load("res://AlgorithmScenes/Code/ADTs/edge_adt.gd");
	[Export]
	private RectangleShape2D clickable_area;
	private float weight = 1.0f;
	[Export]
	private Node2D joint_end1;
	[Export]
	private Node2D joint_end2;
	

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		base._Ready();
		SetProcess(false);
		curr_label = GetNode<Label>("Label");
		line = GetNode<Line2D>("Line2D");
		//edge_collision = GetNode<CollisionShape2D>("Area2D/LineCollision");
		collision_line = GetNode<CollisionShape2D>("Area2D/LineCollision");
		clickable_area = (RectangleShape2D) collision_line.Shape;
	}

	//  // Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(float delta)
	{
		line.SetPointPosition(0, joint_end1.Position);
		line.SetPointPosition(1, joint_end2.Position);

		curr_label.SetPosition(
			(joint_end1.Position + joint_end2.Position) / 2
		);
		set_collision_box();
	}

	public void set_label_and_positions_with_nodes(Node2D node1, Node2D node2, String label_text){
		Vector2[] line_vertices = {node1.Position, node2.Position}; 
		line.Points = line_vertices;
		if (label_text != "") 
		{
			curr_label.Text = label_text;
			this.weight = float.Parse(label_text); // we prefer to receive a string and turn it into a float
		}
		// Since this allows easier rounding
		this.ZIndex = -1;
		this.SetProcess(true);
		joint_end1 = node1;
		joint_end2 = node2;
		this.NodeA = node1.GetPath();
		this.NodeB = node2.GetPath();

	}

	/// <summary>
	/// To set this quad, we will set the extent of the rectangle like the following
	/// extent(x, y) := y will be its margin, x will be its distance
	///	position(x, y) := (node1.position + node2.position) / 2
	///	rotation(alpha) := arctan( (node2.y - node1.y) / (node2.x - node1.x) )
	/// </summary>
	private void set_collision_box(){
		// Set extent of the collision box for the line
		Vector2 pos1 = (Vector2) joint_end1.Get("aux_position");
		Vector2 pos2 = (Vector2) joint_end2.Get("aux_position");
		float distance = Mathf.Sqrt(
			(pos2.y - pos1.y) * (pos2.y - pos1.y) + (pos2.x - pos1.x) * (pos2.x - pos1.x)
		) - 60.0f;
		clickable_area.Extents = new Vector2(distance * 0.5f, 8.0f);
		// Set the position of the collision box
		collision_line.Position = (pos1 + pos2) * 0.5f;
		collision_line.Rotation = Mathf.Atan2(pos2.y - pos1.y, pos2.x - pos1.x);

	}

	public void _on_Area2D_input_event(Viewport viewport, InputEvent @event, int shape_idx) { 
		if (@event is InputEventMouseButton btn && 
			btn.ButtonIndex == (int) ButtonList.Left && @event.IsPressed()) 
		{
			bool are_nodes_clickable = (bool) GetNode("/root/StoredData").Get("allow_select_edges");
			if (are_nodes_clickable) {
				_on_edge_click();
			}
		}
	}

	/// <summary>
	/// Intended to be used for Kruskal and Prim, to order edges
	/// </summary>
	private void _on_edge_click() {
		Node StoredData = GetNode("/root/StoredData");
		StoredData.Set("selected_edge", this);
	}

	public Resource get_adt(){
		return GraphEdge.adt;
	}

	public String get_class(){
		return "GraphEdge";
	}


	public String as_string(){
		return "Edge (" + joint_end1.Get("index") + "-" + joint_end2.Get("index") + ")";
	}

	public Node2D[] get_connecting_nodes(){ 
		return new []{joint_end1, joint_end2};
	}

	public void set_selected(){
		this.Modulate = new Color(1.0f, 0.0f, 0.0f);
	}

	public void set_weight_visible(bool visible_weight){
		curr_label.Visible = visible_weight;
	}

}
