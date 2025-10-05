extends CharacterBody2D

var health_image = preload("res://character_assets/hearts.png")
var half_a_heart = preload("res://character_assets/half heart.png")
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var right = true
@export var health  := 4.5
@export var max_health := 4

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	show_health()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if velocity.y > 0 and not $AnimatedSprite2D.animation == "attack_1":
		$AnimatedSprite2D.play("fall")
	elif velocity.y < 0 and not $AnimatedSprite2D.animation == "attack_1":
		$AnimatedSprite2D.play("jump")
		
	if velocity == Vector2(0,0) and not $AnimatedSprite2D.animation == "attack_1":
		$AnimatedSprite2D.play("default")
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if direction == -1:
			right = false
		else :
			right = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("attack"):
		$AnimatedSprite2D.play("attack_1")
		
		
	if velocity.x != 0 and is_on_floor() and not $AnimatedSprite2D.animation == "attack_1":
		$AnimatedSprite2D.play("run")
	
	if right:
		$AnimatedSprite2D.flip_h = false
		$attack/CollisionShape2D.position.x = 6
	else :
		$AnimatedSprite2D.flip_h = true
		$attack/CollisionShape2D.position.x = -6
		
	move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.play("default")

func show_health():
	$CanvasLayer/Control/RichTextLabel.clear()

	for x in range(floor(health)):
		$CanvasLayer/Control/RichTextLabel.add_image(health_image)
		
	if health - floor(health) == 0.5:
		$CanvasLayer/Control/RichTextLabel.add_image(half_a_heart)

	
