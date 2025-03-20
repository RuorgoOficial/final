using Final.Shared;
using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Emit;
using System.Text;
using System.Threading.Tasks;
using static Godot.TextServer;

namespace Final.Scenes.Agents.Base
{
    public partial class BaseAgents<T> : CharacterBody3D, IAgents<T>
        where T : BaseStats, new()
    {
        private bool IsJumping { get; set; } = false;
        private bool IsAttacking { get; set; } = false;
        private int EnemyIndex { get; set; } = 0;

        private AnimationPlayer _animationPlayer;
        private Sprite3D _sprite;
        private T _stats;

        [Signal]
        public delegate void OnAttackingEventHandler(int index); 
        [Signal]
        public delegate void OnBeattenEventHandler(int index);

        public BaseAgents(int totalExperience) {
            _stats = new();
            GainExp(totalExperience);
        }

        public override void _Ready()
        {
            _animationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
            _sprite = GetNode<Sprite3D>("Sprite3D");

            _animationPlayer.Play(AnimationNames.ANIMATION_IDLE_NAME);
        }

        public int GetHp()
        {
            return _stats.CurrentHp;
        }
        public virtual void ReduceHp(int quantity)
        {
            _stats.CurrentHp -= quantity;
        }
        public int GetStrength()
        {
            return _stats.Strenght;
        }
        public int GetDefense()
        {
            return _stats.Defense;
        }
        public bool GetIsJumping()
        {
            return IsJumping;
        }
        public bool GetIsAttacking()
        {
            return IsAttacking;
        }
        public int GetEnemyIndex()
        {
            return EnemyIndex;
        }
        public void SetEnemyIndex(int enemyIndex)
        {
            EnemyIndex = enemyIndex;
        }

        #region Animation
        public void Attack()
        {
            animation_ATACK();
        }
        public void animation_IDLE()
        {
            IsJumping = false;
            IsAttacking = false;
            _animationPlayer.Play(AnimationNames.ANIMATION_IDLE_NAME);
        }
        public void animation_ATACK()
        {
            IsAttacking = true;
            _animationPlayer.Play(AnimationNames.ANIMATION_ATACK_NAME);
        }
        public void animation_WALK()
        {
            _animationPlayer.Play(AnimationNames.ANIMATION_WALK_NAME);
        }
        public void animation_JUMP_START()
        {
            IsJumping = true;
            _animationPlayer.Play(AnimationNames.ANIMATION_JUMP_START_NAME);
        }
        public void animation_JUMP()
        {
            _animationPlayer.Play(AnimationNames.ANIMATION_JUMP_NAME);
        }
        public void animation_JUMP_END()
        {
            _animationPlayer.Play(AnimationNames.ANIMATION_JUMP_END_NAME);
        }
        public void sprite_direction(int direction)
        {
            if (direction > 0)
            {
                _sprite.FlipH = false;
            }
            else if (direction < 0)
            {
                _sprite.FlipH = true;
            }

        }
        public void OnAnimationFinished(string animationName)
        {
            switch(animationName)
            {
                case AnimationNames.ANIMATION_ATACK_NAME:
                    animation_IDLE();
                    EmitSignal(SignalName.OnAttacking, GetEnemyIndex());
                    break;
                case AnimationNames.ANIMATION_JUMP_START_NAME:
                    animation_JUMP();
                    break;
                case AnimationNames.ANIMATION_JUMP_NAME:
                    animation_JUMP_END();
                    break;
                case AnimationNames.ANIMATION_JUMP_END_NAME:
                    animation_IDLE();
                    break;
            }
        }

        #endregion

        #region Level and Exp
        public virtual void GainExp(int receivedExp)
        {
            if (_stats.level < 99)
            {
                _stats.level_exp = receivedExp;
                _stats.total_exp = receivedExp;
                while (_stats.level_exp >= CalculateRequiredExpByLevel())
                {
                    _stats.level_exp = _stats.level_exp - CalculateRequiredExpByLevel();
                    _stats.level += 1;
                    GrownLevel();
                    if (_stats.level == 99)
                    {
                        _stats.total_exp -= _stats.level_exp;
                        _stats.level_exp = 0;
                    }
                }
            }
        }
        public int GetLevel()
        {
            return _stats.level;
        }
        public void GrownLevel()
        {
            _stats.HP = 100 * _stats.level;
            _stats.CurrentHp = _stats.HP;
            _stats.Strenght = 7 * _stats.level;
            _stats.Vitality = 7 * _stats.level;
            _stats.Agility = 7 * _stats.level;
            _stats.Defense = 7 * _stats.level;
        }
        private int CalculateRequiredExpByLevel()
        {
            return (100 * (_stats.level / 2) * _stats.level);
        }
        #endregion
    }
}
