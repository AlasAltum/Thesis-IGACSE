using Godot;
using System;

public class MainMenu : CanvasLayer
{
	public Node CurrentScene { get; set; }
	private Button startGameButton;
	private Button TutorialButton;
	private Button selectLevelButton;


	private AnimationPlayer animPlayer;

	[Export]
	private Godot.Collections.Array<string> TutorialLevelsPaths = new Godot.Collections.Array<string>();

	private String BFS_TEST = "res://AlgorithmScenes/TestScenes/BFS_test.tscn";
	private String DFS_TEST = "res://AlgorithmScenes/TestScenes/DFS_test.tscn";

	// private AlgorithmSelectionMenu algorithmSelectionMenu;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		startGameButton = GetNode<Button>("VBoxContainer/StartGame");
		TutorialButton = GetNode<Button>("VBoxContainer/TestButton");
		selectLevelButton = GetNode<Button>("VBoxContainer/SelectLevelButton");

		// The exitGame button is not necessary in the HTML version
		//	exitGame = GetNode<Button>("VBoxContainer/ExitGame");
		startGameButton.GrabFocus();

		selectLevelButton.Connect("pressed", this, nameof(OnStartGameButtonPressed));
		selectLevelButton.Connect("pressed", this, nameof(OnSelectLevelButtonPressed));

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

	private void PlayButtonSound() => GetNode<Node>("/root/AudioPlayer").Call("play_button_sound");

	public void OnBackButtonPressed()
	{
		PlayButtonSound();
		Node AudioPlayer = GetNode<Node>("/root/AudioPlayer");
		AudioPlayer.Call("play_button_sound");
		// algorithmSelectionMenu.BackButton.Disabled = true;
		// animPlayer.Play("ShowMenu");
	}

	public void OnStartGameButtonPressed()
	{
		PlayButtonSound();
		startGameButton.Disabled = true;
		GotoScene("res://GameFlow/StoryModeChapterOne.tscn");
	}

	public void OnSelectLevelButtonPressed()
	{
		PlayButtonSound();
		startGameButton.Disabled = true;
		GotoScene("res://GameFlow/AlgorithmSelectionMenu.tscn");
	}


	private void _on_TestButton_pressed()
	{
		PlayButtonSound();

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
			startGameButton.Disabled = false;
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

