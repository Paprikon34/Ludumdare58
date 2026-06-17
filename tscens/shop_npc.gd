extends Area2D

@onready var shop_ui: Control = $CanvasLayer/ShopUI
@onready var souls_label: Label = $CanvasLayer/ShopUI/Panel/SoulsLabel
@onready var buy_dash_btn: Button = $CanvasLayer/ShopUI/Panel/BuyDash
@onready var buy_double_jump_btn: Button = $CanvasLayer/ShopUI/Panel/BuyDoubleJump
@onready var close_btn: Button = $CanvasLayer/ShopUI/Panel/Close
@onready var prompt_label: Label = $PromptLabel

const DASH_COST = 100
const DOUBLE_JUMP_COST = 50

var player: Node2D = null
var player_nearby: bool = false

func _process(_delta: float) -> void:
	# Face the player at all times
	if player:
		if player.global_position.x < global_position.x:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false

	# Open shop on E press when nearby and shop isn't already open
	if player_nearby and Input.is_action_just_pressed("interact") and not shop_ui.visible:
		update_ui()
		shop_ui.visible = true

func _ready() -> void:
	# Build the AnimatedSprite2D frames dynamically
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_animation("idle")
	sprite_frames.set_animation_loop("idle", true)
	sprite_frames.set_animation_speed("idle", 10.0)
	
	for i in range(20):
		var num_str = str(i).pad_zeros(5)
		var path = "res://BlueWizard/2BlueWizardIdle/Chara - BlueIdle" + num_str + ".png"
		var texture = load(path)
		if texture:
			sprite_frames.add_frame("idle", texture)
			
	$AnimatedSprite2D.sprite_frames = sprite_frames
	$AnimatedSprite2D.play("idle")
	
	# Connect signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	buy_dash_btn.pressed.connect(_on_buy_dash_pressed)
	buy_double_jump_btn.pressed.connect(_on_buy_double_jump_pressed)
	close_btn.pressed.connect(_on_close_pressed)
	
	update_ui()

func _on_body_entered(body: Node2D) -> void:
	if body.name.to_lower() == "axi":
		player = body
		player_nearby = true
		prompt_label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.name.to_lower() == "axi":
		player = null
		player_nearby = false
		prompt_label.visible = false
		shop_ui.visible = false

func _on_close_pressed() -> void:
	shop_ui.visible = false

func _on_buy_dash_pressed() -> void:
	if not Global.dash and Global.souls >= DASH_COST:
		Global.souls -= DASH_COST
		Global.dash = true
		update_ui()

func _on_buy_double_jump_pressed() -> void:
	if not Global.double_jump and Global.souls >= DOUBLE_JUMP_COST:
		Global.souls -= DOUBLE_JUMP_COST
		Global.double_jump = true
		update_ui()

func update_ui() -> void:
	souls_label.text = "Souls: " + str(Global.souls)
	
	# Update Dash Button
	if Global.dash:
		buy_dash_btn.text = "Dash: Purchased"
		buy_dash_btn.disabled = true
	else:
		buy_dash_btn.text = "Buy Dash (" + str(DASH_COST) + " Souls)"
		buy_dash_btn.disabled = Global.souls < DASH_COST
		
	# Update Double Jump Button
	if Global.double_jump:
		buy_double_jump_btn.text = "Double Jump: Purchased"
		buy_double_jump_btn.disabled = true
	else:
		buy_double_jump_btn.text = "Buy Double Jump (" + str(DOUBLE_JUMP_COST) + " Souls)"
		buy_double_jump_btn.disabled = Global.souls < DOUBLE_JUMP_COST
