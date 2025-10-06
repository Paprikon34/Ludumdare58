extends Node2D


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#$Sprite2D.texture = preload("res://door/closed door.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


@export var required_souls: int = 5
@export var door_id: String = "door_001"
@export var closed_texture: Texture2D = preload("res://door/closed_door.png")
@export var open_texture: Texture2D = preload("res://door/open_door.png")


@onready var sprite: Sprite2D = $Sprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var area: Area2D = $Area2D

var is_open: bool = false

func _ready() -> void:
	_load_door_state()

func _load_door_state() -> void:
	if GlobalState.is_door_open(door_id):
		_set_open_state(true, play_anim := false)
	else:
		_set_open_state(false, play_anim := false)

func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("player") and not is_open:
		if Input.is_action_just_pressed("interact"):
			_try_open(body)

func _process(delta: float) -> void:
	# handle input while player is inside
	for body in area.get_overlapping_bodies():
		if body.is_in_group("player") and not is_open:
			if Input.is_action_just_pressed("interact"):
				_try_open(body)

func _try_open(player: Node) -> void:
	if player.souls >= required_souls:
		player.souls -= required_souls
		_open()
	else:
		print("Not enough souls to open this door!")

func _open() -> void:
	_set_open_state(true, play_anim := true)
	GlobalState.mark_door_open(door_id)

func _set_open_state(open: bool, play_anim: bool) -> void:
	is_open = open
	if open:
		sprite.texture = open_texture
		$CollisionShape2D.disabled = true
		if play_anim:
			anim.play("open")
	else:
		sprite.texture = closed_texture
		$CollisionShape2D.disabled = false
		if play_anim:
			anim.play("close")
