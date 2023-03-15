using Godot;
using System;

public class MainMenu : Node2D
{
	public Node CurrentScene { get; set; }
	private Button startGame;
	private Button TutorialButton;
//	private Button exitGame;
	private AnimationPlayer animPlayer;

	[Export]
	private Godot.Collections.Array<string> TutorialLevelsPaths = new Godot.Collections.Array<string>();

	private AlgorithmSelectionMenu algorithmSelectionMenu;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		startGame = GetNode<Button>("VBoxContainer/StartGame");
		TutorialButton = GetNode<Button>("VBoxContainer/TestButton");
		// The exitGame button is not necessary in the HTML version
		//		exitGame = GetNode<Button>("VBoxContainer/ExitGame");
		animPlayer = GetNode<AnimationPlayer>("FadeAnimation");
		algorithmSelectionMenu = GetNode<AlgorithmSelectionMenu>("AlgorithmSelectionMenu");

		startGame.GrabFocus();
		startGame.Connect("pressed", this, "OnStartGame");
		//		exitGame.Connect("pressed", this, "OnExitGame");    
		algorithmSelectionMenu.Connect("OnSelectionMenuExitSignal", this, nameof(OnSelectionMenuExit));
		algorithmSelectionMenu.Connect("OnBackButtonPressedSignal", this, nameof(OnBackButtonPressed));

		animPlayer.Connect("animation_finished", this, nameof(onAnimationFinished));
		CurrentScene = this;

		Node2D StoredData = GetTree().Root.GetNode<Node2D>("/root/StoredData");
		if ( (bool) StoredData.Get("has_initialized"))
		{
			animPlayer.Queue("ShowLevelsInstant");
		}
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
		algorithmSelectionMenu.BackButton.Disabled = true;
		animPlayer.Play("ShowMenu");
	}

	public void OnStartGame()
	{
		startGame.Disabled = true;
		animPlayer.Play("ShowLevels");
	}

	public void OnTutorialButtonPressed()
	{
		// TODO: Add levels here
		// TutorialLevelsPaths.Add("");
		// TutorialLevelsPaths.Add("");
		// TutorialLevelsPaths.Add("");
		// TutorialLevelsPaths.Add("");
		TutorialLevelsPaths.Shuffle();
		GotoScene(TutorialLevelsPaths[0]);
	}

	public void onAnimationFinished(String animName)
	{
		if (animName == "ShowLevels")
		{
			startGame.Disabled = false;
		}
		if (animName == "ShowMenu")
		{
			algorithmSelectionMenu.BackButton.Disabled = false;
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
