class_name LuzMala extends Pieza

func _ready():
	body_entered.connect(func(other_body):
		if other_body is Pieza:
			other_body.chocaste_con(self)
	)
