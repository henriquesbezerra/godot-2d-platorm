extends Area2D

func _ready():
	pass 
	
func _on_checkpoint_body_entered(body):
	if body.name == "Player":
		if $AnimationPlayer.assigned_animation != "checked":
			$AnimationPlayer.play("checked")
			$CollisionShape2D.queue_free()
			body.hit_checkpoint()
