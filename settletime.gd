extends RichTextLabel

@onready var timer = get_parent()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		var timeleft = "%.2f" % (timer.time_left)
		text = "RED LINE ENGAGED IN: " + timeleft
		if timeleft == '0.00':
			text = "RED LINE ENGAGED"
