@tool
extends RigidBody2D

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_TRANSFORM_CHANGED:
			position = round(position / 64) * 64
