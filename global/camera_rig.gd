extends Node2D

class_name CameraRig

# ---------- Основные параметры ----------
@export var follow_speed: float = 8.0
@export var cursor_influence: float = 0.2

# ---------- Смещение по скорости ----------
@export var velocity_influence: float = 0.10   # 0.1—0.3 обычно оптимально
@export var max_velocity_offset: float = 20.0   # ограничение, чтобы камера не улетала

var player: Node2D
var player_velocity: Vector2 = Vector2.ZERO

# ---------- Shake-параметры ----------
var shake_time_left: float = 0.0
var shake_strength: float = 0.0
var original_pos_offset := Vector2.ZERO  # базовый оффсет без shake
var shake_offset := Vector2.ZERO          # текущий shake


func _ready() -> void:
	player = get_parent()


func _process(delta: float) -> void:
	if player == null:
		return

	# 1. Базовая позиция игрока
	var base_pos: Vector2 = player.global_position

	# 2. Оффсет к курсору
	var mouse_world = get_global_mouse_position()
	var cursor_offset = (mouse_world - base_pos) * cursor_influence

	# 3. Оффсет по скорости
	var vel_offset := Vector2.ZERO
	if "velocity" in player:
		var v = player.velocity
		if v.length() > 0:
			vel_offset = v.normalized() * max_velocity_offset * velocity_influence

	original_pos_offset = cursor_offset + vel_offset

	# 4. Обновление shake
	_update_shake(delta)

	# 5. Итоговая позиция
	var desired = base_pos + original_pos_offset + shake_offset

	global_position = global_position.lerp(desired, follow_speed * delta)


# SHAKE
# ------------------------------------------------------------------
func shake(duration: float, strength: float) -> void:
	shake_time_left = duration
	shake_strength = strength

func _update_shake(delta: float) -> void:
	if shake_time_left > 0.0:
		shake_time_left -= delta

		# Случайное смещение по X/Y
		shake_offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
	else:
		shake_offset = Vector2.ZERO
