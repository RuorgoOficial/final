using Final.Scenes.Agents.Base;
using Final.Shared;
using Godot;
using System;

public partial class GirlAgent : BaseAgents<BaseStats>
{
    public int EnemyIndex { get; set; } = 0;
    public const float Speed = 2.5f;
    public const float JumpVelocity = 4.5f;

    [Export]
    public bool IsFightingScene { get; set; } = false;

    [Signal]
    public delegate void OnPlayerIsMovingEventHandler();

    public GirlAgent() : base(PlayerManager.TotalExperience)
    {
    }

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        base._Ready();
    }
    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {

    }
    public override void _PhysicsProcess(double delta)
    {
        Vector3 velocity = Velocity;

        // Add the gravity.
        if (!IsOnFloor())
        {
            velocity += GetGravity() * (float)delta;
        }

        // Handle Jump.
        if (Input.IsActionJustPressed("ui_accept") && IsOnFloor())
        {
            velocity.Y = JumpVelocity;
            animation_JUMP_START();
        }

        if (!IsFightingScene)
        {
            if (Input.IsKeyPressed(Key.C))
            {
                animation_ATACK();
            }
            // Get the input direction and handle the movement/deceleration.
            // As good practice, you should replace UI actions with custom gameplay actions.
            Vector2 inputDir = Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down");
            Vector3 direction = (Transform.Basis * new Vector3(inputDir.X, 0, inputDir.Y)).Normalized();
            if (direction != Vector3.Zero)
            {
                velocity.X = direction.X * Speed;
                velocity.Z = direction.Z * Speed;
                sprite_direction((int)direction.X);
                if (!GetIsJumping() && !GetIsAttacking())
                {
                    EmitSignal(SignalName.OnPlayerIsMoving);
                    animation_WALK();
                }
            }
            else
            {
                velocity.X = Mathf.MoveToward(Velocity.X, 0, Speed);
                velocity.Z = Mathf.MoveToward(Velocity.Z, 0, Speed);
                if (!GetIsJumping() && !GetIsAttacking())
                {
                    animation_IDLE();
                }
            }

            Velocity = velocity;
            MoveAndSlide();
        }

    }

    public override void GainExp(int totalExp)
    {
        PlayerManager.TotalExperience = totalExp;
        base.GainExp(totalExp);
    }
}
