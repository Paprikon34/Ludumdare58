extends CharacterBody2D
var g = false



func _process(delta: float) -> void:
	if g == true:
		$Label.modulate.a -= 0.5 * delta
	if g == false:
		$Label.modulate.a += 0.5 * delta






func _on_area_2d_body_entered(body: Node2D) -> void:
	g = false


func _on_area_2d_body_exited(body: Node2D) -> void:
	g = true
