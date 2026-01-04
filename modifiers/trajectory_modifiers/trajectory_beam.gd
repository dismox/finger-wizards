extends TrajectoryModifier
class_name TrajectoryBeam

@export var turn_speed: float = 9999.0
@export var steer_strength: float = 1.0
@export var lock_angle: bool = true

func process(delta: float, bullet: Bullet) -> Vector2:
	var cursor_pos = bullet.get_global_mouse_position()
	var dir = cursor_pos - bullet.global_position

	if dir == Vector2.ZERO:
		return Vector2.ZERO

	# Проверка на достижение курсора
	var step_len = bullet.speed * delta
	if dir.length() <= step_len:
		bullet.global_position = cursor_pos
		bullet.destroy_bullet()
		return Vector2.ZERO

	if lock_angle:
		bullet.rotation = dir.angle()
	else:
		bullet.rotation = lerp_angle(bullet.rotation, dir.angle(), delta * turn_speed)

	var desired_direction = dir.normalized()
	var base_direction = Vector2.RIGHT.rotated(bullet.rotation)

	return (desired_direction - base_direction) * bullet.speed * steer_strength * delta
