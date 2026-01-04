extends TrajectoryModifier
class_name TrajectoryHomingCursor

@export var turn_speed: float = 10.0

func process(delta: float, bullet: Bullet) -> Vector2:
	var cursor_pos = bullet.get_global_mouse_position()
	var dir = (cursor_pos - bullet.global_position).angle()
	bullet.rotation = lerp_angle(bullet.rotation, dir, delta * turn_speed)
	return Vector2.ZERO
