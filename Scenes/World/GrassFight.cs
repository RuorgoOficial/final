using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using static System.Net.Mime.MediaTypeNames;

public partial class GrassFight : Node3D
{
    private FigthingControlUi _control;
    private GirlAgent _player;
    private SceneManager _sceneManager;
    private FightManager _fightManager;

    private RandomNumberGenerator _rng = new RandomNumberGenerator();
    private PackedScene _enemy = ResourceLoader.Load<PackedScene>("res://Scenes/Agents/Enemies/enemy.tscn");

    private List<EnemyAgent> _enemies = new List<EnemyAgent>();


    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        _control = GetNode<FigthingControlUi>("Control");
        _player = GetNode<GirlAgent>("Girl");
        _sceneManager = GetNode<SceneManager>("/root/SceneManager");
        _fightManager = GetNode<FightManager>("/root/FightManager");

        InstantiateEnemies();
        SettupUi();
    }

    private void SettupUi()
    {
        _control.SetInitialPlayerHpProgressBar(_player.GetHp());
        _control.OnEnemyButtonClicked += (int index) => 
            {
                OnControlOnAttackButtonOnPressed(index); 
            };
    }

    private void InstantiateEnemies()
    {
        var quantity = _rng.RandiRange(1, 3);

        for (int i = 0; i < quantity; i++)
        {
            AddEnemy(i, quantity);
            AddEnemyAttackButton(i);
        }
    }

    private void AddEnemyAttackButton(int i)
    {
        _control.AddButtonToPanelEnemySelector(_enemies[i].Name);
    }

    private void AddEnemy(int i, int quantity)
    {
        var enemy = _enemy.Instantiate<EnemyAgent>();
        enemy.SetEnemyIndex(i);
        enemy.Name = $"Enemy{i}";

        var enemyPositionZ = quantity > 1 ? -0.5f + (i / (quantity - 1.0f)) : 0;
        enemy.Position = new Vector3(1.5f, 1.5f, enemyPositionZ);

        enemy.OnBeatten += ReturnToWorldMap;
        enemy.OnAttacking += OnEnemyOnAttacking;
        enemy.OnEnemyTimerTimeout += OnEnemyTimerTimeout;

        AddChild(enemy);
        _enemies.Add(enemy);

    }

    public void ReturnToWorldMap(int index)
    {
        _player.GainExp(_enemies[index].GetGivenExp());
        _enemies.RemoveAt(index);

        if (!_enemies.Any())
            _sceneManager.GoToScene("res://Scenes/World/world.tscn");
    }
    public void OnEnemyOnAttacking(int index)
    {
        var damage = _fightManager.CalculateDamage(_enemies[index], _player);

        _player.ReduceHp(damage);
        _control.SetPlayerHpProgressBar(_player.GetHp());

        _fightManager.RemoveAttacker();
    }
    public void OnGirlOnAttacking(int index)
    {
        var damage = _fightManager.CalculateDamage(_player, _enemies[index]);

        _enemies[index].ReduceHp(damage);

        _fightManager.RemoveAttacker();
    }

    public void OnEnemyTimerTimeout(int index)
    {
        _fightManager.AddAttacker(_enemies[index]);
    }

    public void OnControlOnAttackButtonOnPressed(int index)
    {
        _control.AttackWorkflow();
        _player.EnemyIndex = index;
        _fightManager.AddAttacker(_player);
    }

}
