extends CharacterBody2D

var speed = 150
var player_chase = false
var player = null

@export var health := 3
var deal_demage = 1
var can_deal_damage = true   # <-- declared
var player_in_hitbox = false # Track if player is inside hitbox

func hurt(dmg):
	health -= dmg
	$kaufland_taska_animace.play("hurt")

func _physics_process(delta):
	if player_chase and player:
		position = position.move_toward(player.position, speed * delta)
		$kaufland_taska_animace.flip_h = player.position.x > position.x

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player = body
		player_chase = true
		$kaufland_taska_animace.play("flying")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		player_chase = false
		$kaufland_taska_animace.play("ide")

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player_in_hitbox = true
		if can_deal_damage:
			attack_player()

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_in_hitbox = false
		$kaufland_taska_animace.play("flying")

func attack_player() -> void:
	if not player:
		return
	can_deal_damage = false
	$kaufland_taska_animace.play("atack")
	print(deal_demage)
	# Wait for cooldown
	var timer = get_tree().create_timer(1)
	await timer.timeout
	can_deal_damage = true
	# Attack again if player still in hitbox
	if player_in_hitbox:
		attack_player()
