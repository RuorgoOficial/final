extends Node3D

@onready var control : Control = $Control
@onready var girl: CharacterBody3D = $Girl

var rng = RandomNumberGenerator.new()
var enemy = preload("res://Scenes/Agents/Enemies/enemy.tscn")
var enemy_button = preload("res://Scenes/World/UI/enemy_button.tscn")

var instance = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instantiate_enemy()
	settup_ui()
	
func _process(_delta: float) -> void:
	pass

func instantiate_enemy() -> void:
	var enemy_quantity : int = rng.randi_range(1, 3)
	for i in range(0, enemy_quantity):
		intance_enemy(i, enemy_quantity);
		add_enemy_attack_button(i);
		
func intance_enemy(index: int, enemy_quantity:int) -> void:
	instance.append(enemy.instantiate());
	add_child(instance[index]);
	var enemy_position_z = -0.5 + (index/(enemy_quantity - 1.0)) if enemy_quantity > 1 else 0;
	instance[index].enemy_index = index;
	instance[index].position = Vector3(1.5, 1.5, enemy_position_z);
	instance[index].on_enemy_beaten.connect(self.return_to_world_map, index)
	instance[index].on_attacking.connect(self._on_enemy_on_attacking, index)
	instance[index].on_attack_on_enemy_timer_timeout.connect(self._on_control_on_attack_on_enemy_timer_timeout, index)
	
func add_enemy_attack_button(index: int) -> void:
	var button_instance = enemy_button.instantiate();
	button_instance.on_enemy_button_clicked.connect(self._on_control__on_attack_button_on_pressed, index)
	control.add_button_to_panel_enemy_selector(button_instance);
	
func settup_ui()->void:
	control._set_initial_player_hp_progress_bar(girl.actions.get_hp(girl))
	#foreach()
	#control._set_initial_enemy_hp_progress_bar(instance[0].actions.get_hp(instance[0]))
	
func return_to_world_map(index:int)-> void:
	girl.set_exp(instance[index].given_exp);
	instance.remove_at(index)
	if not instance.any(func(): return true):
		SceneManager.goto_scene("res://Scenes/World/world.tscn")
	
func _on_girl_on_attacking(enemy_index: int) -> void:
	var damage = FightManager.get_damage(girl, instance[enemy_index])
	#control._set_enemy_hp_progress_bar(damage)
	instance[enemy_index].reduce_hp(damage)
	FightManager.remove_attacker()
	
func _on_enemy_on_attacking(enemy_index: int) -> void:
	var damage = FightManager.get_damage(instance[enemy_index], girl)
	girl.reduce_hp(damage)
	control._set_player_hp_progress_bar(damage)
	FightManager.remove_attacker()
	
func _on_control__on_attack_button_on_pressed(index:int) -> void:
	control.attack_workflow();
	girl.enemy_index = index;
	FightManager.add_attacker(girl)

func _on_control_on_attack_on_enemy_timer_timeout(enemy_index: int) -> void:
	FightManager.add_attacker(instance[enemy_index])
