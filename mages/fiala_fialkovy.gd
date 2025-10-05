extends Area2D



@export var upgrade_cost: int = 20 #hodnota ubgradu
@export var upgrade_text: String = "Do you wanna increase stat for {cost} souls?"
@export var player_path: NodePath #pathing pro hrace

var player_in_range: bool = false
var interaction_stage: int = 0  # 0 = žádná interakce, 1 = nabídka, 2 = potvrzení

@onready var bubble_label: Label = $BubbleLabel
@onready var player = get_node(player_path)

func _ready():
	bubble_label.visible = false

func _process(delta):
	if player_in_range:
		if Input.is_action_just_pressed("interact"):
			handle_interaction()

func handle_interaction():
	match interaction_stage:
		0:
			bubble_label.text = "Press E to interact"
			interaction_stage = 1
		1:
			bubble_label.text = upgrade_text.format({"cost": upgrade_cost})
			interaction_stage = 2
		2:
			if player.souls >= upgrade_cost:
				player.souls -= upgrade_cost
				perform_upgrade()
				bubble_label.text = "Upgrade bought!"
			else:
				bubble_label.text = "Not enough souls!"
			interaction_stage = 0

func perform_upgrade():
	player.dash += 5
	$BubbleLabel.text = "Upgrade bought – dash unlocked!"
	$BubbleLabel.visible = true

	# Po 3 sekundách zprava zmizi
	await get_tree().create_timer(3.0).timeout
	$BubbleLabel.visible = false




func _on_npc_ubgrade_body_entered(body: Node2D) -> void:
	player_in_range = true
	bubble_label.text = "Press E to interact"
	bubble_label.visible = true



func _on_npc_ubgrade_body_exited(body: Node2D) -> void:
	player_in_range = false
	bubble_label.visible = false
	interaction_stage = 0
