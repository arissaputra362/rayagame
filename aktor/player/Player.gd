extends KinematicBody2D

#movement
const UP = Vector2(0,-1)

export var gravity = 20
export var max_fall = 300
export var max_speed = 100
export var accel = 20
export var jump_force = 300

var velocity = Vector2()
var body
var running = false

#music
onready var musicNode = $"AudioEffect/AudioStreamPlayer2D"

#healt and status
var health = 3
var hurt_score = 0
var is_in_knockback = false
var is_passed_out = false
var loncat = false

func _ready():
	body = get_node("Body")
	
	get_node("HUDCanvasLayer").update(health)


func hurt(amount = 1):
	if is_in_knockback: return
	health -= amount
	get_node("HUDCanvasLayer").update(health)
	hurt_score += 10
	PlayerData.score = PlayerData.score - hurt_score
	if health <= 0: 
		passed_out()
	else: 
		knockback() 
	
func passed_out():
	print("player passed out.")
	is_passed_out = true
	get_node("AnimationPlayer").play("pass_out")
	musicNode.stop()
	PlayerData.deaths += 1
	queue_free()

func knockback():
	is_in_knockback = true
	get_node("AnimationPlayer").play("flash")
	yield(get_node("AnimationPlayer"), "animation_finished")
	is_in_knockback = false
	

func _process(delta):
	
	if is_passed_out: 
		velocity.x = 0
		return
	
	#pressed
	if Input.is_action_just_pressed("right") or  Input.is_action_just_pressed("left") and di_tanah():
		musicNode.play()
		
	#released
	elif Input.is_action_just_released("right") or Input.is_action_just_released("left"):
		musicNode.stop()
	
	elif Input.is_action_just_pressed("jump") and loncat == false:
		musicNode.stop()
		loncat = true
	
	elif di_tanah() and loncat == true:
		musicNode.play()
		loncat = false
	
func _physics_process(delta):
	grafitasi()		
	move(delta)
	jump()
	animation()
	velocity = move_and_slide(velocity,UP)
	
func grafitasi():
	if !di_tanah():
		velocity.y += gravity
	if velocity.y > max_fall:
		velocity.y = max_fall

func move(_delta):
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	if Input.is_action_pressed("right"):
		velocity.x += accel
		body.flip_h = false
		running = true
		
	elif Input.is_action_pressed("left"):
		velocity.x -= accel
		body.flip_h = true
		running = true
		
	else:
		velocity.x = lerp(velocity.x, 0, 0.2)
		running = false

func jump():
	if di_tanah():
		if Input.is_action_pressed("jump"):
			velocity.y = -jump_force

func animation():
	var anim = "diam"
	if !di_tanah():
		anim = "lompat"
	
	if di_tanah() and running:
		anim = "lari"
		
	body.play(anim)

func di_tanah():
	return $CekTanah.is_colliding()
	
