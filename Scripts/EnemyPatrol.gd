extends KinematicBody2D
# Força de pulo é invertida pq na godot os eixos são invertidos
var jump_force = -720
export var speed = 64
export var health = 1
var velocity = Vector2.ZERO
var move_direction = -1
var gravity = 1200
var hitted = false

func _physics_process(delta):
	velocity.x = speed * move_direction
	velocity.y += gravity * delta
	
	if move_direction == 1:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	
	velocity = move_and_slide(velocity)
	_set_animation()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "idle":
		$Sprite.flip_h != $Sprite.flip_h
		$RayCast2D.scale.x *= -1
		move_direction *= -1
		$AnimationPlayer.play("run")

func _set_animation():
	var anim = "run"
	
	if $RayCast2D.is_colliding():
		anim = "idle"
	elif velocity.x != 0:
		anim = "run"
	
	if hitted:
		anim = "hit"
		
	if $AnimationPlayer.assigned_animation != anim :
		$AnimationPlayer.play(anim)

func _on_Hitbox_body_entered(body):
	hitted = true
	print(body)
	body.velocity.y = jump_force / 2
	health -= 1
	yield(get_tree().create_timer(0.2), "timeout")
	hitted = false
	if health < 1:
		queue_free()
		get_node("Hitbox/CollisionShape2D").set_deferred("disabled", true)
