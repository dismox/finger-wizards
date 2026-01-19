extends Entity
class_name Enemy

enum State {
	IDLE,
	WANDER,
	CHASE,
	ATTACK,
	RETREAT
}

var state: State = State.IDLE

############# АТАКА ############# 

@export var agro_range: float = 300.0
@export var attack_range: float = 120.0
@export var retreat_range: float = 80.0 # для кастеров

@export var attack_cooldown: float = 1.0
var attack_timer: float = 2.0

@export var contact_damage: float = 0.0

############# БЛУЖДАНИЕ ############# 

@export var wander_radius: float = 64.0
@export var wander_interval: float = 2.0
var wander_timer := 0.0
var wander_dir := Vector2.ZERO

############# СТРЕЛЬБА ############# 

@export var shoot_points: Array[Marker2D] = []

@export var bullet_scene: PackedScene
@export var bullet_damage: float = 10.0
@export var bullet_speed: float = 200.0
@export var bullet_range: float = 300.0
@export var bullet_spread: float = 0.0
@export var bullet_multishot: int = 0
@export var trajectory_modifiers: Array[TrajectoryModifier] = []
@export var perks: Array[BulletPerk] = []



func _process_ai(delta: float) -> void:
	if Game.player == null:
		_set_state(State.IDLE)
		return

	attack_timer -= delta

	var to_player := Game.player.global_position - global_position
	var dist := to_player.length()

	if dist > agro_range:
		_set_state(State.WANDER)
	elif dist > attack_range:
		_set_state(State.CHASE)
	elif dist < retreat_range:
		_set_state(State.RETREAT)
	else:
		_set_state(State.ATTACK)

	_process_state(delta, to_player.normalized(), dist)


func _process_state(delta: float, dir: Vector2, dist: float) -> void:
	match state:
		State.IDLE:
			target_velocity = Vector2.ZERO

		State.WANDER:
			_process_wander(delta)

		State.CHASE:
			_process_chase(dir)

		State.RETREAT:
			_process_retreat(dir)

		State.ATTACK:
			_process_attack(dir)


func _set_state(new_state: State) -> void:
	state = new_state

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	_process_contacts()
	_update_sprite_flip()


func _process_contacts() -> void:
	for i in range(get_slide_collision_count()):
		var col := get_slide_collision(i)
		var collider := col.get_collider()

		if collider is Player:
			collider.apply_damage(contact_damage)

func _update_sprite_flip(dir: Vector2 = Vector2.ZERO) -> void:
	if velocity.x != 0:
		if abs(velocity.x) < 1.0:
			return
		sprite.flip_h = velocity.x > 0
	else:
		if abs(dir.x) < 1.0:
			return
		sprite.flip_h = dir.x > 0



func _process_wander(delta: float) -> void:
	wander_timer -= delta
	if wander_timer <= 0:
		wander_timer = wander_interval
		wander_dir = Vector2(
			randf_range(-1, 1),
			randf_range(-1, 1)
		).normalized()

	target_velocity = wander_dir
	#target_velocity = Vector2.ZERO

func _process_chase(dir: Vector2) -> void:
	target_velocity = dir

func _process_retreat(dir: Vector2) -> void:
	target_velocity = -dir


func _process_attack(dir: Vector2) -> void:
	target_velocity = Vector2.ZERO
	if attack_timer <= 0:
		attack_timer = attack_cooldown
		attack(dir)

func attack(dir: Vector2) -> void:
	_update_sprite_flip(dir)
	pass


func shoot(dir: Vector2) -> void:
	for point in shoot_points:
		for i in range (1 + bullet_multishot):
			dir = dir + Vector2(randf_range(-bullet_spread, bullet_spread), randf_range(-bullet_spread, bullet_spread))

			var bullet: Bullet = Game.spawn_bullet(
				bullet_scene,
				point.global_position,
				dir.angle(),
				self,
				bullet_damage,
				bullet_speed,
				bullet_range,
				trajectory_modifiers
			)

			for perk in perks:
				perk.on_shoot(self, bullet)
			
			bullet.hit.connect(_on_bullet_hit)
			bullet.faded.connect(_on_bullet_fade)
			bullet.flight_tick.connect(_on_bullet_flight)


func radial_shoot(dir: Vector2, count: int) -> void:
	for point in shoot_points:
		Game.spawn_radial_bullets(
			bullet_scene,
			point.global_position,
			count,
			self,
			bullet_damage,
			bullet_speed,
			bullet_range,
			dir.angle(),
			trajectory_modifiers
		)


func _on_bullet_hit(bullet: Bullet, target):
	for perk in perks:
		perk.on_bullet_hit(self, bullet, target)

func _on_bullet_fade(bullet: Bullet):
	for perk in perks:
		perk.on_bullet_fade(self, bullet)

func _on_bullet_flight(bullet: Bullet, delta):
	for perk in perks:
		perk.on_bullet_flight(self, bullet, delta)
#########################################################


func _die() -> void:
	Game.spawn_exp(global_position, 1)
	super._die()

func _on_hitbox_area_area_entered(area: Area2D) -> void:
	pass
