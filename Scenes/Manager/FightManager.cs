using Final.Scenes.Agents.Base;
using Final.Shared;
using Godot;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using System.Xml.Linq;

public partial class FightManager : Node
{

    private List<BaseAgents<BaseStats>> _AttackingPool = new List<BaseAgents<BaseStats>>();
    private BaseAgents<BaseStats> _CurrentAttacker = null;

    public void _ready()
    {

    }
    public void _process(float _delta)
    {
        if (_CurrentAttacker == null && _AttackingPool.Any())
        {
            _CurrentAttacker = _AttackingPool.First();
            _CurrentAttacker.Attack();

        }
    }

    public void RemoveAttacker()
    {
        if (_AttackingPool.Any())
        {
            _AttackingPool.RemoveAt(0);
            _CurrentAttacker = null;
        }
    }

    public void RemoveAttackerByNode(BaseAgents<BaseStats> attacker)
    {
        if (_AttackingPool.Any(x => x == attacker))
        {
            var index = _AttackingPool.IndexOf(attacker);
            _AttackingPool.RemoveAt(index);
        }
    }


    public void AddAttacker(BaseAgents<BaseStats> attacker)
    {
        _AttackingPool.Add(attacker);
    }

    public int CalculateDamage(BaseAgents<BaseStats> attacker, BaseAgents<BaseStats> defender)
    {
        return 10 * (attacker.GetStrength() / defender.GetDefense()) + (10 * attacker.GetLevel());
    }

}
