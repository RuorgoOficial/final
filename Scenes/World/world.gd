extends Node3D

@onready var player = $Girl
	
var rng = RandomNumberGenerator.new()
var min_random_encounter_number: int = 0
@export var max_random_encounter_number: int = 100

func _ready() -> void:
	player.position = SceneManager.get_world_last_position();

func random_encounter():
	var random_number = rng.randi_range(min_random_encounter_number, max_random_encounter_number)
	if random_number == 0:
		SceneManager.set_world_last_position(player.position)
		SceneManager.goto_scene("res://Scenes/World/grass_fight.tscn")
	
func _on_girl_on_player_is_moving() -> void:
	random_encounter()
