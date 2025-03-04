extends Node3D

var enemy = preload("res://Scenes/Agents/Enemies/enemy.tscn")
var instance
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instantiate_enemy()

func instantiate_enemy() -> void:
	instance = enemy.instantiate();
	add_child(instance);
	instance.position = Vector3(1.5, 1.5, 0);
	instance.on_enemy_beaten.connect(self.return_to_world_map)
	
func return_to_world_map():
	SceneManager.goto_scene("res://Scenes/World/world.tscn")
	

func _on_girl_on_attacking() -> void:
	instance.reduce_hp()
	
