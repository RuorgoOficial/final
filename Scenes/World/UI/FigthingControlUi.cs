using Godot;
using System;
using System.Reflection;

public partial class FigthingControlUi : Control
{
    private Label PlayerNameLabel; //= $
    private Label PlayerHPLabel; //= $
    private Label PlayerMPLabel; //= $Panel/Panel/
    private ProgressBar PlayerHPProgressBar; //= $
    private ProgressBar PlayerMPProgressBar; //= $Panel/Panel/
    private ProgressBar PlayerActionProgressBar; //= $Panel/Panel/
    private Button AttackButton; //= $
    private Button DefenseButton; //= $Panel/Panel/
    private Button ObjectButton; //= $Panel/Panel/
    private Button RunButton; //= $Panel/Panel/
    private Timer PlayerTimer; //= 
    private ItemList PanelEnemySelector; //= $
    private Button BackButton; //= $


    [Signal]
    public delegate void OnEnemyButtonClickedEventHandler(int index);

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        PlayerNameLabel = GetNode<Label>("Panel/Panel/Player_Name_Label");
        PlayerHPLabel = GetNode<Label>("Panel/Panel/Player_HP_Label");
        PlayerMPLabel = GetNode<Label>("Panel/Panel/Player_MP_Label");

        PlayerHPProgressBar = GetNode<ProgressBar>("Panel/Panel/Player_HP_Progress_Bar");
        PlayerMPProgressBar = GetNode<ProgressBar>("Panel/Panel/Player_MP_Progress_Bar");
        PlayerActionProgressBar = GetNode<ProgressBar>("Panel/Panel/Player_Action_Progress_Bar");

        AttackButton = GetNode<Button>("Panel/Panel/Attack_Button");
        DefenseButton = GetNode<Button>("Panel/Panel/Defense_Button");
        ObjectButton = GetNode<Button>("Panel/Panel/Object_Button");
        RunButton = GetNode<Button>("Panel/Panel/Run_Button");
        BackButton = GetNode<Button>("Panel/Panel/Panel_Enemy_Selector/Back_Button");

        PlayerTimer = GetNode<Timer>("PlayerTimer");

        PanelEnemySelector = GetNode<ItemList>("Panel/Panel/Panel_Enemy_Selector");

        PlayerTimer.WaitTime = 5;
        StartTimmer(PlayerTimer);
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
        SetPlayerTimer();
    }

    public void SetInitialPlayerHpProgressBar(int MaxHp)
    {
        SetInitialProgressBar(PlayerHPProgressBar, MaxHp);
    }
    public void SetPlayerHpProgressBar(int quantity)
    {
        SetProgressBar(PlayerHPProgressBar, quantity);
    }
    public void OnAttackButtonPressed()
    {
        SetAttackButtonVisible(true);
    }
    public void OnPlayerTimerTimeout()
    {
        DisableAttackButton(false);
    }
    public void AttackWorkflow()
    {
        SetAttackButtonVisible(false);
        DisableAttackButton(true);
        StartTimmer(PlayerTimer);
    }
    public void AddButtonToPanelEnemySelector(string name)
    {
        PanelEnemySelector.AddItem(name);
    }
    public void OnPanelEnemySelectorFocusExited()
    {
        SetAttackButtonVisible(false);
    }
    public void OnBackButtonPressed()
    {
        SetAttackButtonVisible(false);
    }
    public void OnPanelEnemySelectorItemClicked(int index, Vector2 _atPosition, int _mouseButtonIndex)
    {
        EmitSignal(SignalName.OnEnemyButtonClicked, index);
    }

    private void StartTimmer(Timer timer)
    {
        timer.Start();
    }
    private void SetPlayerTimer()
    {
        if (PlayerTimer.TimeLeft > 0)
        {
            PlayerActionProgressBar.MaxValue = PlayerTimer.WaitTime;
            PlayerActionProgressBar.Value = PlayerTimer.WaitTime - PlayerTimer.TimeLeft;
        }
    }
    private void DisableAttackButton(bool v)
    {
        AttackButton.Disabled = v;
    }
    private void SetAttackButtonVisible(bool v)
    {
        PanelEnemySelector.Visible = v;
    }
    private void SetProgressBar(ProgressBar progressBar, int quantity)
    {
        progressBar.Value = quantity;
    }
    private void SetInitialProgressBar(ProgressBar progressBar, int maxValue)
    {
        progressBar.MaxValue = maxValue;
        SetProgressBar(progressBar, maxValue);
    }
}
