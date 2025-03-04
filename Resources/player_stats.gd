extends base_stats
class_name player_stats

func stat_growth(target) -> void:
	target.HP += 25
	target.Strenght += 5
	target.Vitality += 5
	target.Agility += 5
	target.Defense += 5
