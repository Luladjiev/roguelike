extends Node2D

signal hit

const actions = {
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}

onready var TILE_SIZE = $TileMap.cell_size
onready var ray_cast = $RayCast2D

func _ready():
#	Snap player to the grid
	position = position.snapped(Vector2.ONE * TILE_SIZE)
	position += Vector2.ONE * TILE_SIZE/2		


func _unhandled_input(event):
	for direction in actions.keys():
		if event.is_action_pressed(direction):
			move(direction)


func _on_Player_hit():
	pass


func move(index):
	var direction = actions[index]
	ray_cast.cast_to = direction * TILE_SIZE
	ray_cast.force_raycast_update()
	if (!ray_cast.is_colliding()):
		position += actions[index] * TILE_SIZE

