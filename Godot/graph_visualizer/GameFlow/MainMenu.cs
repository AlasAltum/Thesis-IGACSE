using Godot;
using System;

public class MainMenu : Node2D
{
    public Node CurrentScene { get; set; }
    private Button startGame;
    private Button exitGame;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        startGame = GetNode<Button>("CanvasLayer/VBoxContainer/StartGame");
        exitGame = GetNode<Button>("CanvasLayer/VBoxContainer/ExitGame");
        startGame.Connect("pressed", this, "OnStartGame");
        exitGame.Connect("pressed", this, "OnExitGame");
        CurrentScene = this;
    }

    public void OnStartGame()
    {
        GotoScene("res://AlgorithmScenes/Algorithms/BFSAlgorithm/BFS.tscn");
    }

    public void OnExitGame()
    {
        GetTree().Quit();
    }

    private void GotoScene(string path)
    {
        // This function will usually be called from a signal callback,
        // or some other function from the current scene.
        // Deleting the current scene at this point is
        // a bad idea, because it may still be executing code.
        // This will result in a crash or unexpected behavior.

        // The solution is to defer the load to a later time, when
        // we can be sure that no code from the current scene is running:

        CallDeferred(nameof(DeferredGotoScene), path);
    }

    private void DeferredGotoScene(string path)
    {
        // It is now safe to remove the current scene
        CurrentScene.QueueFree();

        // Load a new scene.
        var nextScene = (PackedScene) GD.Load(path);

        // Instance the new scene.
        CurrentScene = nextScene.Instance();

        // Add it to the active scene, as child of root.
        GetTree().Root.AddChild(CurrentScene);

        // Optionally, to make it compatible with the SceneTree.change_scene() API.
        GetTree().CurrentScene = CurrentScene;
    }



}
