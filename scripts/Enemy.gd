extends "res://scripts/Actor.gd"

func _ready():
	add_to_group(Groups.ENEMY)

func hit(actor, damage_taken):
	.hit(actor, damage_taken)
	if dead == false:
		.attack(actor)