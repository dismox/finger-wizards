extends Node2D
class_name Bullet

signal shot(bullet: Bullet)
signal faded(bullet: Bullet)
signal flight_tick(bullet: Bullet, delta: float)
signal hit(bullet: Bullet, target: Entity)

var cancel_hit: bool = false

enum BulletState { FLYING, HIT, FADING, DEAD }
var state: BulletState = BulletState.FLYING


var speed: float
var range: float

var damage: float:
	set(value):
		if value < 1.0:
			value = 1.0
		damage = value
		scale = Vector2.ONE * (value / 10.0)


var source: Entity

@export var puddle_type: Game.Puddle_type = Game.Puddle_type.BLUE
@export var bullet_type: Game.Bullet_type = Game.Bullet_type.MANA
@export var main_color: Color = Color.BLUE

var traveled_distance: float = 0.0
var life_time: float = 0.0

var beam: bool = false

var piercing: bool = true
#var bouncing: bool = false
#var pushing: bool = false

@export var trajectory_modifiers: Array[TrajectoryModifier] = []

@onready var particle: CPUParticles2D = $Particle
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var hit_particle: CPUParticles2D = $HitParticle
@onready var area: Area2D = $BulletArea

func _ready() -> void:
	emit_signal("shot", self)


func init(_source: Entity, _damage: float, _speed: float, _range: float) -> void:
	source = _source
	damage = _damage
	speed = _speed
	range = _range

	particle.amount = int(damage) + int(speed/10)
	#scale = Vector2.ONE * (damage / 10.0)

	if beam:
		sprite.play("beam")
	else:
		sprite.play("default")


func _physics_process(delta: float) -> void:
	if state != BulletState.FLYING:
		return
	
	life_time += delta

	var base_move := Vector2.RIGHT.rotated(rotation) * speed * delta
	var extra_move := Vector2.ZERO

	for m in trajectory_modifiers:
		extra_move += m.process(delta, self)

	var movement := base_move + extra_move
	global_position += movement
	traveled_distance += movement.length()

	emit_signal("flight_tick", self, delta)

	if traveled_distance >= range:
		start_fade()


func _on_bullet_area_area_entered(area: Area2D) -> void:
	if state != BulletState.FLYING:
		return

	var object := area.get_parent()
	
	# Столкновение с другой пулей
	if object is Bullet and object != self:
		emit_signal("hit", self, object)
		return
	
	if source and object is Entity and object != source:
		if (object is Enemy and source is Player) or (source is Enemy and object is Player):
			emit_signal("hit", self, object)
			
			object.apply_damage(damage)
			hit_particle.emitting = true

			if cancel_hit:
				cancel_hit = false
				return
				
			#if not piercing:
			start_hit()

func start_hit() -> void:
	state = BulletState.HIT
	disable_interaction()


	if !beam:
		sprite.hide()
		#sprite.play("hit")

	await hit_particle.finished
	await get_tree().create_timer((particle.lifetime + particle.preprocess) * particle.speed_scale).timeout
	queue_free()

func start_fade() -> void:
	if state != BulletState.FLYING:
		return

	state = BulletState.FADING
	disable_interaction()
	emit_signal("faded", self)
	Game.spawn_paddle(global_position, puddle_type, Vector2(0.5, scale.x/2))

	if !beam:
		sprite.play("fade")
		await sprite.animation_finished
		await get_tree().create_timer((particle.lifetime + particle.preprocess) * particle.speed_scale).timeout

	
	queue_free()

func disable_interaction() -> void:
	area.monitoring = false
	area.monitorable = false
	speed = 0
	particle.emitting = false
	%Light.hide()
