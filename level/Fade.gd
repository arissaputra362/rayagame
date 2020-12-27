extends ColorRect

var start_time = 0
var duration = 400

var fade_in = true

func _ready():
	start_time = OS.get_ticks_msec()
	
	set_size(get_viewport_rect().size)
	
	set_process(true)

func _process(delta):
	var alpha = float(OS.get_ticks_msec() - start_time) / duration
	alpha = clamp(alpha, 0, 1)
	
	if fade_in:
		alpha = 1 - alpha
		
	color.a = alpha
