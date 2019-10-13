extends Node2D

signal hit

enum ACTIONS {
	MOVE, ATTACK
}

const inputs = {
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
	for direction in inputs.keys():
		if event.is_action_pressed(direction):
			do_action(direction)


func _on_Player_hit():
	emit_signal("hit")


func do_action(index):
	var direction = inputs[index]

	match(check_tile(direction)):
		ACTIONS.MOVE:
			position += direction * TILE_SIZE


func check_tile(direction):
	ray_cast.cast_to = direction * TILE_SIZE
	ray_cast.force_raycast_update()

	if !ray_cast.is_colliding():
		return ACTIONS.MOVE

	var collider = ray_cast.get_collider()

#	If there is no owner that means that we hit an obstacle
	if !collider.owner:
		return

	var owner = collider.owner

	if owner.is_in_group(Groups.ENEMY):
		print("enemy hit")