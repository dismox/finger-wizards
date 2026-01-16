extends Node2D
class_name Explosion

@export var radius: float = 96.0
@export var max_damage: float = 40.0
@export var max_force: float = 40.0
@export var lifetime: float = 0.15

@export var source: Node
@export var damage_falloff := Curve.new()
@export var force_falloff := Curve.new()

@onready var exlposion_area: Area2D = $ExlposionArea
@onready var shape: CircleShape2D = $ExlposionArea/CollisionShape2D.shape
@onready var timer: Timer = $Timer
@onready var particles: CPUParticles2D = $Particles



func _ready() -> void:
	shape.radius = radius
	timer.wait_time = lifetime
	timer.start()
	#area.body_entered.connect(_on_body_entered)

	# дефолтные кривые (1 в центре → 0 на краю)
	if damage_falloff.get_point_count() == 0:
		damage_falloff.add_point(Vector2(0, 1))
		damage_falloff.add_point(Vector2(1, 0))

	if force_falloff.get_point_count() == 0:
		force_falloff.add_point(Vector2(0, 1))
		force_falloff.add_point(Vector2(1, 0))
		
	particles.emitting = true


func _on_exlposion_area_body_entered(body: Node2D) -> void:
	if not body is Entity:
		return

	var dir := body.global_position - global_position
	var dist := dir.length()

	if dist > radius or dist <= 0.001:
		return

	var t := dist / radius  # 0..1
	var dmg := max_damage * damage_falloff.sample(t)
	var force := max_force * force_falloff.sample(t)

	body.apply_damage(dmg)

	if body.has_method("apply_impulse"):
		body.apply_impulse(dir.normalized() * force)
	elif "target_velocity" in body:
		body.target_velocity += dir.normalized() * force


func _on_timer_timeout() -> void:
	exlposion_area.queue_free()
	timer.wait_time = 3.0
	await timer.timeout
	queue_free()
