extends Node

var attackingPool = Array([], TYPE_OBJECT, "Node", null)
var current_attacker: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if current_attacker == null and attackingPool.any(func(_element): return true):
		current_attacker = attackingPool[0]
		current_attacker.actions.attack(current_attacker)

func remove_attacker() -> void:
	if attackingPool.any(func(_element): return true):
		attackingPool.remove_at(0)
	current_attacker = null
	
func remove_attacker_by_node(attacker: Node) -> void:
	if attackingPool.any(func(_element): _element = attacker):
		var index = attackingPool.find(attacker)
		attackingPool.remove_at(index)
	
func add_attacker(attacker: Node) -> void:
	attackingPool.append(attacker)
	
func get_damage(attacker: Node, defender: Node) -> int:
	return 10 * (attacker.stats.Strenght / defender.stats.Defense) + (10 * attacker.stats.level)
