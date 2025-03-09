extends Resource
class_name agent_actions

func get_hp(tarjet:Node) -> int:
	return tarjet.stats.HP
func attack(tarjet:Node) -> void:
	animation_ATACK(tarjet)
	
#region Animation Region
const ANIMATION_IDLE_NAME : String = "IDLE"
const ANIMATION_ATACK_NAME : String = "ATACK"
const ANIMATION_WALK_NAME : String = "WALK"

const ANIMATION_JUMP_START_NAME : String = "JUMP_START"
const ANIMATION_JUMP_NAME : String = "JUMP"
const ANIMATION_JUMP_END_NAME : String = "JUMP_END"

var is_jumping : bool = false
var is_attacking: bool = false

func animation_IDLE(tarjet:Node):
	is_jumping = false
	is_attacking = false
	tarjet.animation_player.play(ANIMATION_IDLE_NAME)
	
func animation_ATACK(tarjet:Node):
	is_attacking = true
	tarjet.animation_player.play(ANIMATION_ATACK_NAME)
	
func animation_WALK(tarjet:Node) -> void: 
	tarjet.animation_player.play(ANIMATION_WALK_NAME)
	
func animation_JUMP_START(tarjet:Node) -> void: 
	is_jumping = true
	tarjet.animation_player.play(ANIMATION_JUMP_START_NAME)
	
func animation_JUMP(tarjet:Node) -> void: 
	tarjet.animation_player.play(ANIMATION_JUMP_NAME)
	
func animation_JUMP_END(tarjet:Node) -> void: 
	tarjet.animation_player.play(ANIMATION_JUMP_END_NAME)
	
func sprite_direction(tarjet:Node, direction:int) -> void:
	if direction > 0:
		tarjet.sprite3D.flip_h = false
	elif direction < 0:
		tarjet.sprite3D.flip_h = true
#endregion
