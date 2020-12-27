extends VideoPlayer

var aspect_ratio = 16.0/9.0
var vid_length = 17.6

export var next_scene : PackedScene

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")

func _ready():
	
	get_tree().set_pause(true)
	
	var vsize = get_viewport_rect().size
	
	get_parent().get_node("ColorRect").set_size(vsize)
	
	if vsize.y < vsize.x / aspect_ratio:
		set_size(Vector2(vsize.y * aspect_ratio, vsize.y))
		set_position(Vector2(vsize.x - vsize.y * aspect_ratio) / 2.0)
	
	else:
		set_size(Vector2(vsize.x ,vsize.x / aspect_ratio))
		set_position(Vector2(0, (vsize.y - vsize.x / aspect_ratio)))

	set_process(true)

func _process(delta):
	if get_stream_position() >= vid_length:
		get_tree().set_pause(false)
		get_parent().queue_free()
		get_tree().change_scene_to(next_scene)
