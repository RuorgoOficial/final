using Godot;
using System;
using System.IO;

public partial class SceneManager : Node
{
    private Node _currentScene = null;
    private Vector3 _worldLastPosition = new Vector3(0, 1.2f, 0);

	public void _ready()
	{
		var root = GetTree().Root;
        _currentScene = root.GetChild(root.GetChildCount() - 1);
    }

	public void GoToScene(string path)
	{
		CallDeferred(nameof(DeferredGoToScene), path);
	}

	public void DeferredGoToScene(string path)
	{
		_currentScene.Free();
		var s = ResourceLoader.Load<PackedScene>(path);
		_currentScene = s.Instantiate();

		GetTree().Root.AddChild(_currentScene);
		GetTree().CurrentScene = _currentScene;

    }

    public void SetWorldLastPosition(Vector3 position) {
        _worldLastPosition = position;
    }
    public Vector3 GetWorldLastPosition()
	{
		return _worldLastPosition;
	}
}


