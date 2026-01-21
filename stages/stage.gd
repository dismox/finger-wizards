extends Node2D

class_name Stage

@export var player_spawn_point: Marker2D
@export var enemy_spawn_points: Array[Marker2D]

@onready var spawn_timer: Timer = $SpawnTimer
@onready var wave_timer: Timer = $WaveTimer


var enemies_pool: Array
var wave_counter: int = 0

var guard = "res://objects/entities/enemies/guard/guard.tscn"
var trooper = "res://objects/entities/enemies/trooper/trooper.tscn"
var heavy_trooper = "res://objects/entities/enemies/heavy_trooper/heavy_trooper.tscn"
var rocket_trooper = "res://objects/entities/enemies/rocket_trooper/rocket_trooper.tscn"
var sniper = "res://objects/entities/enemies/sniper/sniper.tscn"


func _ready() -> void:
	enemies_pool = [
	guard, guard,
	trooper, trooper, trooper,
	heavy_trooper, heavy_trooper,
	rocket_trooper,
	sniper,
	]

func spawn_enemies():
	wave_counter += 1
	var current_pool = enemies_pool.slice(0, wave_counter)
	
	for i in range(wave_counter):
		var scene_patch = current_pool.pick_random()
		var scene: PackedScene = load(scene_patch)
		Game.spawn_entity(scene, enemy_spawn_points[randi() % enemy_spawn_points.size()].global_position) #+ Vector2(randf()*20,randf()*20))
		spawn_timer.start()
		await spawn_timer.timeout
		
	wave_timer.start(3.0 * wave_counter)
	await wave_timer.timeout
	spawn_enemies()
