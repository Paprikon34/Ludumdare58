extends CharacterBody2D

var health_image = preload("res://character_assets/hearts.png")
var half_a_heart = preload("res://character_assets/half heart.png")
var empty_health = preload("res://character_assets/empty hp.png")
const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var right = true
var is_dashing = false
var is_healing = false

func _ready() -> void:
	Global.dash = true

func _process(_delta: float) -> void:
	show_health()
	$CanvasLayer/Control/Label.text = str(Global.souls)
	if Input.is_action_just_pressed("heal") and is_on_floor() and not is_healing:
		$AnimatedSprite2D.play("dash")
		$healing.start()
		is_healing = true
	if Input.is_action_just_released("heal"):
		is_healing = false
		$healing.stop()
		$AnimatedSprite2D.play("default")
		
func _on_healing_timeout() -> void:
	if Global.souls > 0 and Global.hp_current < Global.hp_max:
		Global.souls -= 1
		Global.hp_current += 1
		# Keep healing only if player is still holding heal
		if Input.is_action_pressed("heal"):
			$healing.start()
		else:
			is_healing = false
			$AnimatedSprite2D.play("default")
	else:
		is_healing = false
		$healing.stop()
		$AnimatedSprite2D.play("default")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_healing:
		velocity.y = JUMP_VELOCITY
		
	if velocity.y > 0 and not $AnimatedSprite2D.animation == "attack_1" and not is_dashing and not is_healing:
		$AnimatedSprite2D.play("fall")
	elif velocity.y < 0 and not $AnimatedSprite2D.animation == "attack_1" and not is_dashing and not is_healing:
		$AnimatedSprite2D.play("jump")
		
	if velocity == Vector2(0,0) and not $AnimatedSprite2D.animation == "attack_1" and not is_dashing and not is_healing:
		$AnimatedSprite2D.play("default")
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction and not is_healing:
		velocity.x = direction * SPEED
		if direction == -1:
			right = false
		else :
			right = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("attack") and not is_dashing and not is_healing:
		attack()
		$AnimatedSprite2D.play("attack_1")
		
		
	if velocity.x != 0 and is_on_floor() and not $AnimatedSprite2D.animation == "attack_1" and not is_dashing and not is_healing:
		$AnimatedSprite2D.play("run")
	
	if right:
		$AnimatedSprite2D.flip_h = false
		$attack/CollisionShape2D.position.x = 6
	else:
		$AnimatedSprite2D.flip_h = true
		$attack/CollisionShape2D.position.x = -6
		
	if Global.dash:
		var veloc : float
		if Input.is_action_just_pressed("dash"):
			if direction:
				$dash_lenght.start()
				is_dashing = true
				veloc = velocity.y
				$AnimatedSprite2D.play("dash")
		if Input.is_action_pressed("dash") and is_dashing:
			if direction:
				velocity.x = direction * 10000
				velocity.y = veloc
				if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
					Input.action_release("dash")
			else:
				Input.action_release("dash")
		if Input.is_action_just_released("dash"):
			is_dashing = false
			$dash_lenght.stop()
	move_and_slide()

func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.play("default")

func show_health():
	$CanvasLayer/Control/RichTextLabel.clear()
	$"CanvasLayer/Control/empty hps".clear()

	for x in range(floor(Global.hp_current)):
		$CanvasLayer/Control/RichTextLabel.add_image(health_image)
		
	if Global.hp_current - floor(Global.hp_current) == 0.5:
		$CanvasLayer/Control/RichTextLabel.add_image(half_a_heart)
		
	for x in range(floor(Global.hp_max)):
		$"CanvasLayer/Control/empty hps".add_image(empty_health)

func _on_dash_lenght_timeout() -> void:
	$dash_lenght.stop()
	is_dashing = false

func attack():
	pass
