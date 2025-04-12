class_name Pieza extends RigidBody2D

func esta_bloqueada():
	return false

func _process(delta: float) -> void:
	if esta_bloqueada():
		modulate = Color.GRAY

func chocaste_con(otra_pieza):
	pass
