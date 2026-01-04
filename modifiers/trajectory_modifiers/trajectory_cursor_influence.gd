extends TrajectoryModifier
class_name TrajectoryCursorInfluence

@export var strength: float = 0.2

var last_cursor: Vector2 = Vector2.ZERO
var cursor_velocity: Vector2 = Vector2.ZERO

func process(delta: float, bullet: Bullet) -> Vector2:
	var cursor = bullet.get_global_mouse_position()
	
	if last_cursor != Vector2.ZERO:
		cursor_velocity = (cursor - last_cursor) / delta

	last_cursor = cursor
	
	return cursor_velocity * strength * delta
