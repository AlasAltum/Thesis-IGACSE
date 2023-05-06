extends EffectCheck
# BFS

func _trigger_on_next_line_side_effect() -> void:
	if NotificationManager.animation_player:
		NotificationManager.animation_player.queue("ShowCode")
		NotificationManager.animation_player.show_code()
	
