extends Entity
class_name Player

@export var max_mana = 100.0
@export var mana_regeneration: float = 0.5
var mana: float:
	set(value):
		mana = value
		emit_signal("mana_changed", mana)
		
var restore_mana_boost: float = 0.0

#@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var left_hand: Hand = $AnimatedSprite2D/LeftSleeve/LeftHand
@onready var right_hand: Hand = $AnimatedSprite2D/RightSleeve/RightHand
@onready var camera_rig: CameraRig = $CameraRig

var input_vector: Vector2 = Vector2.ZERO

signal mana_changed(value: float)

@export var all_upgrades: Array[Upgrade] = []

func _ready() -> void:
	Game.player = self
	health = max_health
	mana = max_mana
	#left_hand.add_upgrade(
	

func _physics_process(delta: float) -> void:
	_process_input()
	target_velocity = input_vector
	super._physics_process(delta)
	_process_aiming()
	restore_mana()

func _process_input() -> void:
	input_vector = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()

func _process_aiming() -> void:
	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - global_position).angle()

	left_hand.rotation = dir - 1.8
	right_hand.rotation = dir - 1.8


func _on_hitbox_area_area_entered(area: Area2D) -> void:
	var bullet = area.get_parent()
	if area.get_parent() is Bullet and bullet.source != self:
		apply_damage(bullet.damage)

func apply_damage(amount: float) -> void:
	camera_rig.shake(0.2, amount)
	
	super.apply_damage(amount)
	
func _die() -> void:
	health = max_health
	emit_signal("health_changed", self, health)
	position = Vector2.ZERO

func restore_mana():
	mana += mana_regeneration + restore_mana_boost
	mana = clamp(mana, mana, max_mana)
	
