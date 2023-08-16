using Godot;
using System;

public class AlgorithmSelectionMenu : CanvasLayer
{
	[Export]
	private bool cheatLevels = false; // Unblock all levels automatically

	[Export]
	private bool playerHasFinishedBFSAndDFS = false;
	private bool playerHasFinishedBFS = false;

	[Export]
	private String BFS_SCENE = "res://AlgorithmScenes/Algorithms/BFSAlgorithm/BFS.tscn";

	[Export]
	private String DFS_SCENE = "res://AlgorithmScenes/Algorithms/DFSAlgorithm/DFS.tscn";

	[Export]
	private String PRIM_SCENE = "res://AlgorithmScenes/Algorithms/PrimAlgorithm/Prim_styled.tscn";

	[Export]
	private String KRUSKAL_SCENE = "res://AlgorithmScenes/Algorithms/KruskalAlgorithm/Kruskal_styled.tscn";

	[Export]
	private String BACK_SCENE = "res://GameFlow/MainMenu.tscn";
		
	private Button BFSButton;
	private Button DFSButton;
	private Button PrimButton;
	private Button KruskalButton;
	public Button BackButton;

	[Signal]
	delegate void OnSelectionMenuExitSignal();

	[Signal]
	delegate void OnBackButtonPressedSignal();

	[Signal]
	delegate void OnTutorialButtonPressedSignal();

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		SetButtonsAndConnectTheirSignals();
		SetLevelsBlockedAndUnblocked();
	}

	private void SetButtonsAndConnectTheirSignals()
	{
		BFSButton = GetNode<Button>("GridContainer/BFS");
		DFSButton = GetNode<Button>("GridContainer/DFS");
		PrimButton = GetNode<Button>("GridContainer/Prim");
		KruskalButton = GetNode<Button>("GridContainer/Kruskal");
		BackButton = GetNode<Button>("BackButton");

		BFSButton.Connect("pressed", this, nameof(OnBFSButtonPressed));
		DFSButton.Connect("pressed", this, nameof(OnDFSButtonPressed));
		PrimButton.Connect("pressed", this, nameof(OnPrimButtonPressed));
		KruskalButton.Connect("pressed", this, nameof(OnKruskalButtonPressed));
		BackButton.Connect("pressed", this, nameof(OnBackButtonPressed));
	}


	private void SetLevelsBlockedAndUnblocked()
	{
		DFSButton.Disabled = true;
		PrimButton.Disabled = true;
		KruskalButton.Disabled = true;

		if (cheatLevels)
		{
			Node2D StoredData = GetTree().Root.GetNode<Node2D>("/root/StoredData");
			if (StoredData == null)
				return;

			Godot.Collections.Dictionary finishedLevels = (Godot.Collections.Dictionary) StoredData.Get("finished_levels");

			if (finishedLevels != null)
			{
				finishedLevels["BFS"] = true;
				finishedLevels["DFS"] = true;
			}
		}

	}

	public override void _Process(float delta)
	{
		base._Process(delta);
		ComputePlayerHasFinishedBFSAndDFS();
		if (playerHasFinishedBFS)
		{
			DFSButton.Disabled = false;
		}
		if (playerHasFinishedBFSAndDFS)
		{
			PrimButton.Disabled = false;
			KruskalButton.Disabled = false;
		}
	}

	/// <summary>
	/// Check in the StoredData singleton the variable finished_levels, which is a dictionary of type <Str, bool>
	/// Indicating the names of each level and whether the player has finished it. If BFS and DFS are finished,
	/// unblock next levels, Prim and Kruskal
	/// </summary>
	private void ComputePlayerHasFinishedBFSAndDFS()
	{
		Node2D StoredData = GetTree().Root.GetNode<Node2D>("/root/StoredData");
		if (StoredData != null){
			Godot.Collections.Dictionary finishedLevels = (Godot.Collections.Dictionary) StoredData.Get("finished_levels");
			
			if (finishedLevels != null)
			{
				playerHasFinishedBFS = (bool) finishedLevels["BFS"];
				playerHasFinishedBFSAndDFS = (bool) finishedLevels["BFS"] && (bool) finishedLevels["DFS"];
			}
		}
	}

	public void OnBFSButtonPressed() => GotoScene(BFS_SCENE);

	public void OnDFSButtonPressed() => GotoScene(DFS_SCENE);
	
	public void OnPrimButtonPressed() => GotoScene(PRIM_SCENE);
	
	public void OnKruskalButtonPressed() => GotoScene(KRUSKAL_SCENE);
	
	public void OnBackButtonPressed() => GotoScene(BACK_SCENE);

	public void OnExitGame() => GetTree().Quit();

	private void GotoScene(string path)
	{
		Node2D StoredData = GetTree().Root.GetNode<Node2D>("/root/StoredData");
		StoredData.Set("has_initialized", true);
		CallDeferred(nameof(DeferredGotoScene), path);
	}

	private void DeferredGotoScene(string path)
	{
		var nextScene = (PackedScene) GD.Load(path);
		var CurrentScene = nextScene.Instance();
		GetTree().Root.AddChild(CurrentScene);
		GetTree().CurrentScene = CurrentScene;
		this.QueueFree();
	}

	public override void _Input(InputEvent @event)
	{
		if (@event.IsActionPressed("CheatForMenu") )
		{
			cheatLevels = true;
			SetLevelsBlockedAndUnblocked();
		}
	}

}
