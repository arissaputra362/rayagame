extends KinematicBody2D

const FLOOR_NORMAL: = Vector2.UP

export var speed: = Vector2(30.0, 100.0)
export var gravity: = 400.0

var _velocity: = Vector2.ZERO
var enemy
var flip

func _ready() -> void:
	set_physics_process(false)
	_velocity.x = -speed.x
	enemy = get_node("enemy")
	flip = true


func _on_Area2D_body_entered(body):
	if body.has_method("hurt"):
		body.hurt()

func _physics_process(delta:float) ->	void:
	_velocity.y += gravity*delta
	if is_on_wall():
		_velocity.x *= -1.0
		if flip == true:
			flip = false
			enemy.flip_h = true;
		else:
			flip = true
			enemy.flip_h = false
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
		
