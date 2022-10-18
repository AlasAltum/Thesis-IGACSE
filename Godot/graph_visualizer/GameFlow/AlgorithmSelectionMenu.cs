using Godot;
using System;

public class AlgorithmSelectionMenu : Node2D
{
    public Node CurrentScene { get; set; }

    [Export]
    private bool playerHasFinishedBFSAndDFS = false;
    private bool playerHasFinishedBFS = false;

    private const String BFS_SCENE = "res://AlgorithmScenes/Algorithms/BFSAlgorithm/BFS_styled.tscn";
    private const String DFS_SCENE = "res://AlgorithmScenes/Algorithms/DFSAlgorithm/DFS_styled.tscn";
    private const String PRIM_SCENE = "res://AlgorithmScenes/Algorithms/PrimAlgorithm/Prim_styled.tscn";
    private const String KRUSKAL_SCENE = "res://AlgorithmScenes/Algorithms/KruskalAlgorithm/Kruskal_styled.tscn";
    private Button BFSButton;
    private Button DFSButton;
    private Button PrimButton;
    private Button KruskalButton;
    public Button BackButton;

    [Signal]
    delegate void OnSelectionMenuExitSignal();

    [Signal]
    delegate void OnBackButtonPressedSignal();
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
    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        BFSButton = GetNode<Button>("GridContainer/BFS");
        DFSButton = GetNode<Button>("GridContainer/DFS");
        PrimButton = GetNode<Button>("GridContainer/Prim");
        KruskalButton = GetNode<Button>("GridContainer/Kruskal");
        BackButton = GetNode<Button>("BackButton");

        DFSButton.Disabled = true;
        PrimButton.Disabled = true;
        KruskalButton.Disabled = true;

        BFSButton.Connect("pressed", this, nameof(OnBFSButtonPressed));
        DFSButton.Connect("pressed", this, nameof(OnDFSButtonPressed));
        PrimButton.Connect("pressed", this, nameof(OnPrimButtonPressed));
        KruskalButton.Connect("pressed", this, nameof(OnKruskalButtonPressed));
        BackButton.Connect("pressed", this, nameof(OnBackButtonPressed));
        

        CurrentScene = GetTree().Root.GetNode("MainMenu");
        if (CurrentScene.Name == "MainMenu")
        {
            CurrentScene = this;
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
            CallDeferred("SetProcess" , false);
        }
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

    public void OnBackButtonPressed()
    {
        EmitSignal("OnBackButtonPressedSignal");
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
        this.QueueFree();
        EmitSignal("OnSelectionMenuExitSignal");
        var nextScene = (PackedScene) GD.Load(path);
        CurrentScene = nextScene.Instance();
        GetTree().Root.AddChild(CurrentScene);
        GetTree().CurrentScene = CurrentScene;
    }


}
