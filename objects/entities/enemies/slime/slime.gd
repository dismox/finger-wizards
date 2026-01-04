extends Enemy
class_name SlimeEnemy

@export var dash_speed: float = 350.0
@export var dash_duration: float = 0.25
@export var slide_duration: float = 0.35
@export var dash_cooldown: float = 1.8

@export var contact_damage: float = 20.0
@export var bounce_force: float = 150.0        # сила отскока

var phase: String = "idle"                     # idle → dash → slide → cooldown
var phase_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	super._ready()

func _init() -> void:
	agro_range = 1000.0
	friction = 1.0

func _process_ai(delta: float) -> void:
	if Game.player == null:
		target_velocity = Vector2.ZERO
		return

	var to_player := Game.player.global_position - global_position
	var dist := to_player.length()

	phase_timer -= delta

	match phase:
		"idle":
			if dist <= agro_range:
				_start_dash(to_player.normalized())

		"dash":
			# активно летим вперёд
			target_velocity = dash_direction

			if phase_timer <= 0.0:
				_start_slide()

		"slide":
			# замедленное скольжение
			# используем interpolation на понижение скорости
			velocity = velocity.lerp(Vector2.ZERO, delta * (1.0 / slide_duration))
			target_velocity = Vector2.ZERO

			if phase_timer <= 0.0:
				_start_cooldown()

		"cooldown":
			target_velocity = Vector2.ZERO
			if phase_timer <= 0.0:
				phase = "idle"


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	_process_collisions()

func _start_dash(direction: Vector2) -> void:
	Game.spawn_radial_bullets(bullet_scene, global_position,
	5, self, 30.0 * scale.x, 100.0 / scale.x, 400.0 * scale.x, randf() * TAU)
	
	phase = "dash"
	phase_timer = dash_duration
	dash_direction = direction
	velocity = direction * dash_speed
	
	

func _start_slide() -> void:
	phase = "slide"
	phase_timer = slide_duration
	# скорость остаётся от рывка → затем плавно затухает


func _start_cooldown() -> void:
	phase = "cooldown"
	phase_timer = dash_cooldown


func _bounce_from(body: Node) -> void:
	# направление отскока — от точки столкновения
	var away = (global_position - body.global_position).normalized()

	# моментальный толчок от объекта
	velocity = away * bounce_force

	# переводим слизня в фазу скольжения, чтобы выглядело естественно
	phase = "slide"
	phase_timer = slide_duration


func _process_collisions() -> void:
	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()

		if collider is Entity:
			_handle_entity_collision(collider, collision.get_normal())


func _handle_entity_collision(entity: Entity, normal: Vector2) -> void:
	# Урон игроку
	if entity is Player:
		entity.apply_damage(contact_damage)

	# Отскок
	var bounce_dir := normal.normalized()
	velocity = bounce_dir * bounce_force

	# Переходим в скольжение
	phase = "slide"
	phase_timer = slide_duration


func apply_damage(amount: float) -> void:
	super.apply_damage(amount)
	Game.spawn_paddle(global_position, Game.Puddle_type.GREEN, Vector2(0.5, scale.x))

func _die() -> void:
	if max_health > 20.0:
		for i in range (2):
			var scene: PackedScene = load("res://objects/entities/enemies/slime/slime.tscn")
			var new_slime = Game.spawn_entity(scene, global_position + Vector2(10 * i, 10 * i))
			new_slime.scale = scale / 1.5
			new_slime.max_health = clamp(max_health - 40.0, 1.0, max_health - 40.0)
	super._die()
