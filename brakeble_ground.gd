extends Area2D

@export var contact_time: float = 1.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		await get_tree().create_timer(contact_time).timeout
		queue_free()
