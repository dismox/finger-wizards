extends CharacterBody2D
class_name Entity

## ПАРАМЕТРЫ

@export var title: String = "Неизвестно"

@export var move_speed: float = 150.0
@export var acceleration: float = 8.0
@export var friction: float = 10.0

@export var max_health: float = 100.0
var health: float


## ПОДГОТОВКА

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var target_velocity: Vector2 = Vector2.ZERO

signal died(entity: Entity)
signal health_changed(entity: Entity, new_health: float)

func _ready() -> void:
	health = max_health

func _physics_process(delta: float) -> void:
	_process_movement(delta)
	_process_ai(delta)

func _process_movement(delta: float) -> void:
	# target_velocity задается ИЗВНЕ (AI или Player)
	if target_velocity != Vector2.ZERO:
		velocity = velocity.lerp(target_velocity * move_speed, acceleration * delta)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction * delta)

	move_and_slide()

func _process_ai(delta: float) -> void:
	pass


## БОЕВАЯ ЛОГИКА
func apply_damage(amount: float) -> void:
	Game.flash_effect(sprite, Color(18.892, 18.892, 18.892, 1.0))
	health -= amount
	emit_signal("health_changed", self, health)

	if health <= 0:
		_die()

func _die() -> void:
	emit_signal("died", self)
	queue_free()
