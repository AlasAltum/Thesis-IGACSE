using Godot;
using System;

public class MainMenu : CanvasLayer
{
	public Node CurrentScene { get; set; }
	private Button startGameButton;
	private Button selectLevelButton;
	private Button languageButton;

	private enum Language { English, Spanish };
	private Language currentLanguage = Language.English;

	[Export]
	private Godot.Collections.Array<string> TutorialLevelsPaths = new Godot.Collections.Array<string>();

	[Export]
	private PackedScene storyModeFirstLevelPath; // "res://GameFlow/StoryModeChapterOne.tscn"; 

	[Export]
	private PackedScene algorithmSelectionMenuScene; // "res://GameFlow/AlgorithmSelectionMenu.tscn";

	// private AlgorithmSelectionMenu algorithmSelectionMenu;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		startGameButton = GetNode<Button>("MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/StartGame");
		selectLevelButton = GetNode<Button>("MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/SelectLevelButton");
		languageButton = GetNode<Button>("LanguageButton");
		// The exitGame button is not necessary in the HTML version
		//	exitGame = GetNode<Button>("MarginContainer/VBoxContainer/ExitGame");
		startGameButton.GrabFocus();

		startGameButton .Connect("pressed", this, nameof(OnStartGameButtonPressed));
		selectLevelButton.Connect("pressed", this, nameof(OnSelectLevelButtonPressed));
		languageButton.Connect("pressed", this, nameof(OnLanguageButtonPressed));

		CurrentScene = this;
		TranslationServer.SetLocale("en"); // By default it should be spanish
		Node2D StoredData = GetTree().Root.GetNode<Node2D>("/root/StoredData");
		StoredData.Set("world_node", this);
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
	}

	public void OnStartGameButtonPressed()
	{
		PlayButtonSound();
		startGameButton.Disabled = true;
		GotoScene(storyModeFirstLevelPath.ResourcePath);
	}

	public void OnSelectLevelButtonPressed()
	{
		PlayButtonSound();
		startGameButton.Disabled = true;
		GotoScene(algorithmSelectionMenuScene.ResourcePath);
	}

	private void SetCurrentLanguage(Language inLanguage)
	{
		currentLanguage = inLanguage;
		Node2D StoredData = GetTree().Root.GetNode<Node2D>("/root/StoredData");

		if (currentLanguage == Language.Spanish)
		{
			StoredData.Call("set_language", "es");
			languageButton.Text = "Español";
		}
		else if (currentLanguage == Language.English)
		{
			StoredData.Call("set_language", "en");
			languageButton.Text = "English";
		}
	}

	public void OnLanguageButtonPressed()
	{
		PlayButtonSound();
		Node2D StoredData = GetTree().Root.GetNode<Node2D>("/root/StoredData");

		// For now, we can only toggle between English and Spanish
		switch (currentLanguage)
		{
			case Language.English:
				SetCurrentLanguage(Language.Spanish);
				break;
			case Language.Spanish:
				SetCurrentLanguage(Language.English);
				break;
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

