extends Node2D
class_name PickupObject

@export var pickup_radius: float = 100.0
@export var attract_speed: float = 300.0
@export var orbit_strength: float = 500.0
@export var max_pickup_distance: float = 5.0
@export var spiral_angular_speed: float = 3.0 # угловая скорость спирали
@export var self_rotation_speed: float = 10.0 # вращение объекта

var _player: Node2D = null
var _attracting := false
var _orbit_angle := 0.0

@onready var pickup_area: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D


func _ready() -> void:
	var shape := CircleShape2D.new()
	shape.radius = pickup_radius
	collision_shape.shape = shape


func _physics_process(delta: float) -> void:
	if not _attracting or _player == null:
		return

	var to_player := _player.global_position - global_position
	var distance := to_player.length()

	if distance <= max_pickup_distance:
		_on_picked()
		return

	# Нормализованное направление к игроку
	var dir := to_player.normalized()

	# Перпендикуляр для вращения вокруг игрока
	var tangent := Vector2(-dir.y, dir.x)

	# Радиальная + угловая составляющие
	var radial_velocity := dir * attract_speed
	var angular_velocity = tangent * spiral_angular_speed * clamp(distance / pickup_radius, 0.3, 1.0)

	var velocity = radial_velocity + angular_velocity
	global_position += velocity * delta

	# Вращение самого объекта
	rotation += self_rotation_speed * delta
	
	var new_scale = scale - Vector2(0.03, 0.03)
	scale = clamp(new_scale, Vector2.ZERO, new_scale)



func _on_body_entered(body: Node) -> void:
	if _attracting:
		return

	if body is Player:
		_player = body
		_attracting = true
		on_attract_started(body)


# Хук для наследников (визуал, звук и т.п.)
func on_attract_started(player: Node) -> void:
	pass


func _on_picked() -> void:
	apply_to_player(_player)
	queue_free()


# ВИРТУАЛЬНЫЙ МЕТОД
func apply_to_player(player: Node) -> void:
	push_warning("apply_to_player() not implemented")
