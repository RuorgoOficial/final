using Final.Scenes.Agents.Base;
using Final.Shared;
using Godot;
using System;

public partial class EnemyAgent : BaseAgents<BaseStats>
{
    private Timer _timer;
    [Export]
    public int GivenExp = 100;
    [Signal]
    public delegate void OnEnemyTimerTimeoutEventHandler(int i);
    public EnemyAgent() : base(100)
    {
    }

    public override void _Ready()
    {
        base._Ready();
        SetGivenExp();
    }

    public int GetGivenExp()
    {
        return GivenExp;
    }
    private void SetGivenExp()
    {
        GivenExp = GetLevel() * GivenExp;
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
