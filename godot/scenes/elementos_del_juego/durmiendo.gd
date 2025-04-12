extends Pieza
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var durmiendo: bool = true

func esta_bloqueada():
	return durmiendo

func chocaste_con(otra_pieza):
	if durmiendo and otra_pieza is LuzMala:
		animated_sprite_2d.play("despierto")
		durmiendo = false
		modulate = Color.WHITE
