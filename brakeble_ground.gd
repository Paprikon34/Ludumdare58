extends Area2D

var is_broken = false

func _on_body_entered(body: Node) -> void:
	print("[BreakableGround] Entered: ", body.name, " (is_broken: ", is_broken, ")")
	if is_broken:
		return
	if body is CharacterBody2D or body.name == "Axi":
		is_broken = true
		print("[BreakableGround] Player detected! Collapsing in 1 second...")
		await get_tree().create_timer(1.0).timeout
		
		print("[BreakableGround] Hiding and disabling collisions now.")
		hide()
		var col1 = get_node_or_null("CollisionShape2D2")
		if col1:
			col1.set_deferred("disabled", true)
		var col2 = get_node_or_null("StaticBody2D/CollisionShape2D")
		if col2:
			col2.set_deferred("disabled", true)
			
		await get_tree().create_timer(10.0).timeout
		
		print("[BreakableGround] Respawning platform now.")
		show()
		if col1:
			col1.set_deferred("disabled", false)
		if col2:
			col2.set_deferred("disabled", false)
		is_broken = false

func _on_body_exited(body: Node) -> void:
	pass

