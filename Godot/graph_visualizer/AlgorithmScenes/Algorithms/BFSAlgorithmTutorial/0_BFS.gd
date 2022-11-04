extends EffectCheck


func _trigger_on_next_line_side_effect() -> void:
	if StoredData.animation_player:
		StoredData.animation_player.play("ShowCode")
		StoredData.animation_player.show_code()
	
