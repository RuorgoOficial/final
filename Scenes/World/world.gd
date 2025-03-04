extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
var rng = RandomNumberGenerator.new()
var min_random_encounter_number: int = 0
@export var max_random_encounter_number: int = 100

func random_encounter():
	var random_number = rng.randi_range(min_random_encounter_number, max_random_encounter_number)
	if random_number == 0:
		SceneManager.goto_scene("res://Scenes/World/grass_fight.tscn")
	
func _on_girl_on_player_is_moving() -> void:
	random_encounter()
