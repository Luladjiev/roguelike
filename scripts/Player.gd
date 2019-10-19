extends "res://scripts/Actor.gd"

const inputs = {
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}

func _ready():
	add_to_group(Groups.PLAYER)


func _unhandled_input(event):
	for direction in inputs.keys():
		if event.is_action_pressed(direction):
			do_action(direction)


func do_action(index):
	var direction = inputs[index]

	var tile = .get_next_tile_info(direction)

	match tile.info:
		TILE_INFO.FREE:
			.move(direction)
		TILE_INFO.ENEMY:
			print("================")
			.attack(tile.enemy)

