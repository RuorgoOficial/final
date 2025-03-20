using Final.Scenes.Agents.Base;
using Final.Shared;
using Godot;
using System;

public partial class EnemyAgent : BaseAgents<BaseStats>
{
    private Timer _timer;
    private int _givenExp = 100;
    [Signal]
    public delegate void OnEnemyTimerTimeoutEventHandler(int i);
    public EnemyAgent() : base(500)
    {

    }
    public override void _Ready()
    {
        //_timer = GetNode<Timer>("Timer");
        //_timer.Start();
        base._Ready();
    }

    public int GetGivenExp()
    {
        return _givenExp;
    }
    public void SetGivenExp(int givenExp)
    {
        _givenExp = givenExp;
    }

    public override void ReduceHp(int quantity)
    {
        base.ReduceHp(quantity);
        if (GetHp() <= 0)
            EmitSignal(SignalName.OnBeatten, GetEnemyIndex());
    }
    public void OnTimerTimeout()
    {
        EmitSignal(SignalName.OnEnemyTimerTimeout, GetEnemyIndex());
    }
}
