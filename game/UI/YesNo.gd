extends CanvasLayer

signal yesno

func _on_Yes_pressed():
	emit_signal("yesno","yes")
	queue_free()

func _on_No_pressed():
	emit_signal("yesno","no")
	queue_free()
