extends Node3D

@onready var control : Control = $Control
@onready var girl: CharacterBody3D = $Girl

var enemy = preload("res://Scenes/Agents/Enemies/enemy.tscn")
var instance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instantiate_enemy()
	settup_ui()
	
func _process(_delta: float) -> void:
	pass

func instantiate_enemy() -> void:
	instance = enemy.instantiate();
	add_child(instance);
	instance.position = Vector3(1.5, 1.5, 0);
	instance.on_enemy_beaten.connect(self.return_to_world_map)
	instance.on_attacking.connect(self._on_enemy_on_attacking)
	
func settup_ui()->void:
	control._set_initial_player_hp_progress_bar(girl.actions.get_hp(girl))
	control._set_initial_enemy_hp_progress_bar(instance.actions.get_hp(instance))
	
func return_to_world_map():
	SceneManager.goto_scene("res://Scenes/World/world.tscn")
	
func _on_girl_on_attacking() -> void:
	var damage = FightManager.get_damage(girl, instance)
	print_debug("Girl damage: "+str(damage))
	control._set_enemy_hp_progress_bar(damage)
	instance.reduce_hp(damage)
	FightManager.remove_attacker()
	if(instance.current_hp <= 0):
		girl.set_exp(instance.given_exp);
	
func _on_enemy_on_attacking() -> void:
	var damage = FightManager.get_damage(instance, girl)
	print_debug("Enemy damage: "+str(damage))
	girl.reduce_hp(damage)
	control._set_player_hp_progress_bar(damage)
	FightManager.remove_attacker()
	
func _on_control__on_attack_button_on_pressed() -> void:
	FightManager.add_attacker(girl)

func _on_control_on_attack_on_enemy_timer_timeout() -> void:
	FightManager.add_attacker(instance)
