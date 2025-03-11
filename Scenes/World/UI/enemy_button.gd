extends Control

var enemy_index:int = 0

signal on_enemy_button_clicked(enemy_index:int)

func _on_enemy_button_pressed() -> void:
	on_enemy_button_clicked.emit(enemy_index);
