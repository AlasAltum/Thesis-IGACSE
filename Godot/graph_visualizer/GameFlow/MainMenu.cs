using Godot;
using System;

public class MainMenu : Node2D
{
    public Node CurrentScene { get; set; }
    private Button startGame;
    private Button exitGame;
    private AnimationPlayer animPlayer;

    private AlgorithmSelectionMenu algorithmSelectionMenu;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        startGame = GetNode<Button>("VBoxContainer/StartGame");
        exitGame = GetNode<Button>("VBoxContainer/ExitGame");
        animPlayer = GetNode<AnimationPlayer>("FadeAnimation");
        algorithmSelectionMenu = GetNode<AlgorithmSelectionMenu>("AlgorithmSelectionMenu");

        startGame.Connect("pressed", this, "OnStartGame");
        exitGame.Connect("pressed", this, "OnExitGame");    
        algorithmSelectionMenu.Connect("OnSelectionMenuExitSignal", this, nameof(OnSelectionMenuExit));
        algorithmSelectionMenu.Connect("OnBackButtonPressedSignal", this, nameof(OnBackButtonPressed));

        animPlayer.Connect("animation_finished", this, nameof(onAnimationFinished));
        CurrentScene = this;
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

}
