extends Node2D

class_name Stage

@export var player_spawn_point: Marker2D
@export var enemy_spawn_points: Array[Marker2D]
var enemies_pool: Array

func _ready() -> void:
	enemies_pool = [
	"res://objects/entities/enemies/guard/guard.tscn",
	"res://objects/entities/enemies/guard/guard.tscn",
	"res://objects/entities/enemies/guard/guard.tscn",
	"res://objects/entities/enemies/guard/guard.tscn",
	
	"res://objects/entities/enemies/trooper/trooper.tscn",
	"res://objects/entities/enemies/trooper/trooper.tscn",
	"res://objects/entities/enemies/trooper/trooper.tscn",
	
	"res://objects/entities/enemies/heavy_trooper/heavy_trooper.tscn",
	"res://objects/entities/enemies/heavy_trooper/heavy_trooper.tscn",
	
	"res://objects/entities/enemies/rocket_trooper/rocket_trooper.tscn",
	
	"res://objects/entities/enemies/sniper/sniper.tscn",
	]

func spawn_enemies():
	for point in enemy_spawn_points:
		var scene_patch = enemies_pool.pick_random()
		var scene: PackedScene = load(scene_patch)
		Game.spawn_entity(scene, point.global_position + Vector2(randf()*20,randf()*20))
	
