extends Node2D

export var max_health = 0
var health

onready var TILE_SIZE = $TileMap.cell_size

func _ready():
	add_to_group(Groups.ENEMY)
#	Snap player to the grid
	position = position.snapped(Vector2.ONE * TILE_SIZE)

	health = max_health


func hit(actor, damage):
	print("enemy hit: %s damage" % damage)

	health -= damage

	if health <= 0:
		queue_free()
		return

	actor.hit(self, 2)