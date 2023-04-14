using Godot;
using System;

public class MainMenu : CanvasLayer
{
	public Node CurrentScene { get; set; }
	private Button startGame;
	private Button TutorialButton;

	private AnimationPlayer animPlayer;

	[Export]
	private Godot.Collections.Array<string> TutorialLevelsPaths = new Godot.Collections.Array<string>();

	private String BFS_TEST = "res://AlgorithmScenes/TestScenes/BFS_test.tscn";
	private String DFS_TEST = "res://AlgorithmScenes/TestScenes/DFS_test.tscn";

	// private AlgorithmSelectionMenu algorithmSelectionMenu;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		startGame = GetNode<Button>("VBoxContainer/StartGame");
		TutorialButton = GetNode<Button>("VBoxContainer/TestButton");
		// The exitGame button is not necessary in the HTML version
		//	exitGame = GetNode<Button>("VBoxContainer/ExitGame");
		startGame.GrabFocus();
		startGame.Connect("pressed", this, "OnStartGame");

		CurrentScene = this;

		Node2D StoredData = GetTree().Root.GetNode<Node2D>("/root/StoredData");
	}


	/// When the selection menu shows a new scene, we want the whole menu
	/// to dissapear. If we exit just from the AlgorithmSelectionMenu, there will be
	/// assets loaded from the MainMenu, causing unpredictable behavior, therefore
	/// We have to free this scene also
	public void OnSelectionMenuExit()
	{
		CurrentScene.QueueFree();
	}

	public void OnBackButtonPressed()
	{
		// algorithmSelectionMenu.BackButton.Disabled = true;
		// animPlayer.Play("ShowMenu");
	}

	public void OnStartGame()
	{
		startGame.Disabled = true;
		GotoScene("res://GameFlow/AlgorithmSelectionMenu.tscn");
	}


	private void _on_TestButton_pressed()
	{
		// We are assuming that TutorialLevelsPaths contains the test levels in the editor
		GD.Print("OnTutorialButtonPressed");
		// Generate random number, with 50% probability, choose BFS or DFS
		Random rand = new Random();
		int randNum = rand.Next(0, 2);
		if (randNum == 0)
		{
			GotoScene(DFS_TEST);
		}
		else if (randNum == 1)
		{
			GotoScene(BFS_TEST);
		}
	}

	public void onAnimationFinished(String animName)
	{
		if (animName == "ShowLevels")
		{
			startGame.Disabled = false;
		}
	}

	public void OnExitGame()
	{
		GetTree().Quit();
	}


	private void GotoScene(string path)
	{
		Node2D StoredData = GetTree().Root.GetNode<Node2D>("/root/StoredData");
		StoredData.Set("has_initialized", true);
		CallDeferred(nameof(DeferredGotoScene), path);
	}

	private void DeferredGotoScene(string path)
	{
		CurrentScene.QueueFree();
		this.QueueFree();
		var nextScene = (PackedScene) GD.Load(path);
		CurrentScene = nextScene.Instance();
		GetTree().Root.AddChild(CurrentScene);
		GetTree().CurrentScene = CurrentScene;
	}


}

