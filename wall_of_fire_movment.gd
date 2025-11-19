extends Area2D

var wall_attack := false
@onready var wall_of_fire = get_node("../WallOfFire")

func _process(delta: float) -> void:
	if wall_attack:
		position.x -= 399 * delta

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		await get_tree().create_timer(5.0).timeout
		wall_attack = true

	if body is CharacterBody2D and not body.is_dead:
		if body.has_method("death"):
			body.death()
