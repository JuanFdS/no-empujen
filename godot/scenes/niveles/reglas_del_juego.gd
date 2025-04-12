extends Node2D

const VELOCIDAD_DE_PIEZA = 1000
var pieza_siendo_arrastrada: RigidBody2D = null
var punto_de_ancla: Vector2 = Vector2.ZERO
@onready var salida: Area2D = %Salida
@export var pieza_objetivo: RigidBody2D
var resuelto: bool = false
@export_file("*.tscn") var next_scene: String

func _ready() -> void:
	%ParaQueSoloSalgaElObjetivo.add_collision_exception_with(pieza_objetivo)
	salida.body_entered.connect(func(body):
		if body == pieza_objetivo:
			ganaste()
	)
	for pieza in get_tree().get_nodes_in_group("pieza"):
		pieza.freeze = true
		pieza.input_event.connect(self.on_pieza_input_event.bind(pieza))
		pieza.mouse_entered.connect(self.on_pieza_mouse_entered.bind(pieza))
		pieza.mouse_exited.connect(self.on_pieza_mouse_exited.bind(pieza))

func on_pieza_mouse_entered(pieza):
	if pieza == pieza_siendo_arrastrada:
		return
	pieza.modulate = Color.AQUAMARINE

func on_pieza_mouse_exited(pieza):
	if pieza == pieza_siendo_arrastrada:
		return
	pieza.modulate = Color.WHITE

func empezar_a_arrastrar(pieza: RigidBody2D):
	punto_de_ancla = get_global_mouse_position() - pieza.global_position
	pieza.freeze = false
	pieza_siendo_arrastrada = pieza
	pieza.modulate = Color.MEDIUM_AQUAMARINE

func dejar_de_arrastrar(pieza):
	pieza.freeze = true
	pieza.modulate = Color.WHITE
	create_tween().tween_property(
		pieza,
		"global_position",
		round(pieza.global_position / 64) * 64,
		0.2).set_trans(Tween.TRANS_ELASTIC)
	pieza_siendo_arrastrada = null

func on_pieza_input_event(viewport: Node, event: InputEvent, shape_idx: int, pieza: RigidBody2D):
	if resuelto or pieza.esta_bloqueada():
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			empezar_a_arrastrar(pieza)

func _physics_process(delta: float) -> void:
	if resuelto:
		pieza_objetivo.freeze = false
		pieza_objetivo.linear_velocity = Vector2.LEFT * VELOCIDAD_DE_PIEZA
		return
	if pieza_siendo_arrastrada:
		var posicion_origen = pieza_siendo_arrastrada.global_position
		var posicion_destino = get_global_mouse_position() - punto_de_ancla
		pieza_siendo_arrastrada.linear_velocity =\
			posicion_origen.direction_to(posicion_destino) * VELOCIDAD_DE_PIEZA
		if posicion_origen.distance_to(posicion_destino) < pieza_siendo_arrastrada.linear_velocity.length() * delta:
			pieza_siendo_arrastrada.linear_velocity = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if resuelto:
		return
	if event is InputEventMouseButton and pieza_siendo_arrastrada:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.is_pressed():
			dejar_de_arrastrar(pieza_siendo_arrastrada)

func ganaste():
	dejar_de_arrastrar.call_deferred(pieza_siendo_arrastrada)
	resuelto = true
	$"../UI/Ganaste/AnimationPlayer".play("ganaste")
