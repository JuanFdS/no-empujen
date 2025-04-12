extends Button

func _pressed() -> void:
	await %FadeOverlay.fade_in()
	var next_scene = %ReglasDelJuego.next_scene
	get_tree().change_scene_to_file(next_scene)
