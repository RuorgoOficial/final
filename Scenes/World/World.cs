using Godot;
using System;

public partial class World : Node3D
{
    private GirlAgent _player;
    private SceneManager _sceneManager;

    private RandomNumberGenerator _rng = new RandomNumberGenerator();
	private int _minRandomEncounter = 0;
	[Export]
	public int maxRandomEncounter = 100;

	// Called when the node enters the scene tree for the first time.
    public override void _Ready()
	{
        _sceneManager = GetNode<SceneManager>("/root/SceneManager");

        _player = GetNode<GirlAgent>("Girl");
		_player.SetPosition(_sceneManager.GetWorldLastPosition());
    }

	public void OnPlayerIsMoving()
    {
        RandomEncounter();
    }

    private void RandomEncounter()
    {
        var randomNumber = _rng.RandiRange(_minRandomEncounter, maxRandomEncounter);
        if (randomNumber == 0)
        {
            _sceneManager.SetWorldLastPosition(_player.Position);
            _sceneManager.GoToScene("res://Scenes/World/grass_fight.tscn");
        }
    }
}
