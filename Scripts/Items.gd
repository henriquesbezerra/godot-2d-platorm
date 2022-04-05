extends Area2D

export var fruits = 1

func _on_Items_body_entered(body):
	$AnimationPlayer.play("Collected")
	Global.fruits += fruits
#	print(Global.fruits)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Collected":
		queue_free()
