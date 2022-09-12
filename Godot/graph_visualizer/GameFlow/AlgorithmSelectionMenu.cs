using Godot;
using System;

public class AlgorithmSelectionMenu : Node2D
{
   public Node CurrentScene { get; set; }

   private const String BFS_SCENE = "res://AlgorithmScenes/Algorithms/BFSAlgorithm/BFS.tscn";
   private const String DFS_SCENE = "res://AlgorithmScenes/Algorithms/DFSAlgorithm/DFS.tscn";
   private const String PRIM_SCENE = "res://AlgorithmScenes/Algorithms/KruskalAlgorithm/Kruskal2.tscn";
   private const String KRUSKAL_SCENE = "res://AlgorithmScenes/Algorithms/PrimAlgorithm/Prim2.tscn";

    private Button BFSButton;
    private Button DFSButton;
    private Button PrimButton;
    private Button KruskalButton;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        BFSButton = GetNode<Button>("CanvasLayer/GridContainer/BFS");
        DFSButton = GetNode<Button>("CanvasLayer/GridContainer/DFS");
        // Get StoredData singleton
        Node2D StoredData = GetTree().Root.GetNode<Node2D>("/root/StoredData");
        bool playerHasFinishedBFSAndDFS = false;
        if (StoredData != null){
            Godot.Collections.Dictionary<String, bool> finishedLevels = (Godot.Collections.Dictionary) StoredData.Get("finished_levels");
            if (finishedLevels != null)
            {
                playerHasFinishedBFSAndDFS = finishedLevels["BFS"] && finishedLevels["DFS"];
            }
        }
        PrimButton = GetNode<Button>("CanvasLayer/GridContainer/Prim");
        KruskalButton = GetNode<Button>("CanvasLayer/GridContainer/Kruskal");

        BFSButton.Connect("pressed", this, "OnBFSButtonPressed");
        DFSButton.Connect("pressed", this, "OnDFSButtonPressed");
        PrimButton.Connect("pressed", this, "OnPrimButtonPressed");
        KruskalButton.Connect("pressed", this, "OnKruskalButtonPressed");
        CurrentScene = this;
    }

    public void OnBFSButtonPressed()
    {
        GotoScene(BFS_SCENE);
    }

    public void OnDFSButtonPressed()
    {
        GotoScene(DFS_SCENE);
    }
    public void OnPrimButtonPressed()
    {
        GotoScene(PRIM_SCENE);
    }
    public void OnKruskalButtonPressed()
    {
        GotoScene(KRUSKAL_SCENE);
    }

    public void OnExitGame()
    {
        GetTree().Quit();
    }

    private void GotoScene(string path)
    {
        CallDeferred(nameof(DeferredGotoScene), path);
    }

    private void DeferredGotoScene(string path)
    {
        CurrentScene.QueueFree();
        var nextScene = (PackedScene) GD.Load(path);
        CurrentScene = nextScene.Instance();
        GetTree().Root.AddChild(CurrentScene);
        GetTree().CurrentScene = CurrentScene;
    }


}
