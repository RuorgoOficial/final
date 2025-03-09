extends Node

var current_scene = null
var world_last_position:Vector3 = Vector3(0, 1.2, 0)

func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene(path: String) -> void:
	call_deferred("_deferred_goto_scene", path)
	
func _deferred_goto_scene(path: String) -> void:
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene

func set_world_last_position(position:Vector3):
	world_last_position = position;
	
func get_world_last_position() -> Vector3:
	return world_last_position;
