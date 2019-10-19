extends Node

func _ready():
	randomize()

func damage(min_damage, max_damage):
	return floor(rand_range(min_damage, max_damage))

func crit(chance):
	return randf() <= chance

func dodge(chance):
	return randf() <= chance
