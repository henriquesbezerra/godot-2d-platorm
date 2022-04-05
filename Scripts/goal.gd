extends Area2D

onready var changer = get_parent().get_node("Transition_In")

export var path : String 

#func _ready():
#	print(path)
#	pass
#

func _on_goal_body_entered(body):
	if body.name == "Player":
		$Particles2D.emitting = true
		if path :
			changer.change_scene(path)
			Global.checkopoint_pos = 0

