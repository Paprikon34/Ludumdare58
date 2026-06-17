extends CharacterBody2D

var health_image = preload("res://character_assets/hearts.png")
var half_a_heart = preload("res://character_assets/half heart.png")
var empty_health = preload("res://character_assets/empty hp.png")
const SPEED = 150.0
const JUMP_VELOCITY = -250.0
var right = true
var is_dashing = false
var can_dash = true
var is_healing = false
var is_dead = false
var jumps_remaining = 2


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if not is_dead:
		if Input.is_action_just_pressed("ui_end"):
			death()
		
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
	if not is_dead:
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		var max_jumps = 2 if Global.double_jump else 1
		if is_on_floor():
			jumps_remaining = max_jumps
		elif jumps_remaining == max_jumps:
			jumps_remaining = max_jumps - 1

		if Input.is_action_just_pressed("jump") and not is_healing:
			if is_on_floor():
				velocity.y = JUMP_VELOCITY
				jumps_remaining = max_jumps - 1
			elif jumps_remaining > 0:
				velocity.y = JUMP_VELOCITY
				jumps_remaining -= 1
			
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
			
		if Global.dash == true:
			var veloc : float
			if Input.is_action_just_pressed("dash") and can_dash:
				if direction:
					$dash_lenght.start()
					is_dashing = true
					can_dash = false
					veloc = velocity.y
					$AnimatedSprite2D.play("dash")
			if Input.is_action_pressed("dash") and is_dashing:
				if direction:
					velocity.x = direction * 400
					velocity.y = veloc
					if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
						Input.action_release("dash")
				else:
					Input.action_release("dash")
			if Input.is_action_just_released("dash") and is_dashing:
				end_dash()
		move_and_slide()

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "death":
		$"CanvasLayer/end screen".show()
		var tween = create_tween()
		tween.tween_property($"CanvasLayer/end screen", "modulate:a", 1.0, 1.0)
	else:
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
	end_dash()

func end_dash() -> void:
	if is_dashing:
		is_dashing = false
		$dash_lenght.stop()
		$dash_cooldown.start()

func _on_dash_cooldown_timeout() -> void:
	can_dash = true

func attack():
	await get_tree().create_timer(0.145).timeout
	$attack/CollisionShape2D.disabled = false
	await get_tree().create_timer(0.065).timeout
	$attack/CollisionShape2D.disabled = true

func damaged(dmg):
	if not is_dead:
		Global.hp_current -= dmg
		if Global.hp_current == 0:
			death()
		else:
			for x in range(4):
				modulate.a = 0
				await get_tree().create_timer(0.07).timeout
				modulate.a = 255
				await get_tree().create_timer(0.07).timeout

func _on_attack_body_entered(body: Node2D) -> void:
	if body.has_method("hurt"):
		body.hurt(Global.dmg)

func death():
	is_dead = true
	$AnimatedSprite2D.play("death")
