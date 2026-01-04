extends Node2D

func _ready():
	# чтобы системный курсор исчез
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(delta):
	global_position = get_global_mouse_position()
