extends Control

@onready var Player_Name_Label = $Panel/Panel/Player_Name_Label
@onready var Player_HP_Label = $Panel/Panel/Player_HP_Label
@onready var Player_MP_Label = $Panel/Panel/Player_MP_Label
@onready var Player_HP_Progress_Bar : ProgressBar = $Panel/Panel/Player_HP_Progress_Bar
@onready var Player_MP_Progress_Bar : ProgressBar = $Panel/Panel/Player_MP_Progress_Bar
@onready var Player_Action_Progress_Bar : ProgressBar = $Panel/Panel/Player_Action_Progress_Bar
@onready var Attack_Button = $Panel/Panel/Attack_Button
@onready var Defense_Button = $Panel/Panel/Defense_Button
@onready var Object_Button = $Panel/Panel/Object_Button
@onready var Run_Button = $Panel/Panel/Run_Button
@onready var Player_Timer: Timer = $PlayerTimer

@onready var Enemy_Name_Label = $Panel/Panel2/Enemy_Name_Label
@onready var Enemy_HP_Label = $Panel/Panel2/Enemy_HP_Label
@onready var Enemy_MP_Label = $Panel/Panel2/Enemy_MP_Label
@onready var Enemy_HP_Progress_Bar : ProgressBar = $Panel/Panel2/Enemy_HP_Progress_Bar
@onready var Enemy_MP_Progress_Bar : ProgressBar = $Panel/Panel2/Enemy_MP_Progress_Bar
@onready var Enemy_Timer: Timer = $EnemyTimer

signal _on_attack_button_on_pressed
signal on_attack_on_enemy_timer_timeout

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player_Timer.wait_time = 5;
	Enemy_Timer.wait_time = 8
	start_timmer(Player_Timer)
	start_timmer(Enemy_Timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	set_player_timer()
	
func set_player_timer():
	if Player_Timer.time_left > 0:
		Player_Action_Progress_Bar.max_value = Player_Timer.wait_time
		Player_Action_Progress_Bar.value = Player_Timer.wait_time - Player_Timer.time_left;

func _set_initial_player_hp_progress_bar(max_hp)->void:
	set_initial_progress_bar(Player_HP_Progress_Bar, max_hp)
func _set_initial_enemy_hp_progress_bar(max_hp)->void:
	set_initial_progress_bar(Enemy_HP_Progress_Bar, max_hp)
	
func _set_player_hp_progress_bar(cuantity:int)->void:
	set_progress_bar(Player_HP_Progress_Bar, cuantity)
func _set_enemy_hp_progress_bar(cuantity:int)->void:
	set_progress_bar(Enemy_HP_Progress_Bar, cuantity)
	
func set_initial_progress_bar(progress_bar: ProgressBar, max_value: int)->void:
	progress_bar.max_value = max_value
	progress_bar.value = max_value
	
func set_progress_bar(progress_bar: ProgressBar, cuantity: int)->void:
	progress_bar.value -= cuantity
func start_timmer(timer: Timer) -> void:
	timer.start()

func _on_attack_button_pressed() -> void:
	disable_attack_button(true)
	start_timmer(Player_Timer)
	_on_attack_button_on_pressed.emit()

func _on_player_timer_timeout() -> void:
	disable_attack_button(false)

func _on_enemy_timer_timeout() -> void:
	on_attack_on_enemy_timer_timeout.emit()
	start_timmer(Enemy_Timer)
	
func disable_attack_button(isEnable:bool)-> void:
	Attack_Button.disabled = isEnable;
