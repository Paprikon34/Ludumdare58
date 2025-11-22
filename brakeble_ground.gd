extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	print("Entered:", body, "Name:", body.name, "Type:", body.get_class())
	if body is CharacterBody2D or body.name == "Axi":
		queue_free()
  	
