extends KinematicBody2D

var UP = Vector2.UP

# Movimentação no eixo x,y
var velocity = Vector2.ZERO

# Velocidade de movimento
var move_speed = 480
# Gravidade
var gravity = 1200

# Força de pulo é invertida pq na godot os eixos são invertidos
var jump_force = -720

var player_health = 3
var max_health = 3

var hurted = false
var knockback_dir = 1
var knockback_intensiy = 500

signal change_life(health)

func _ready():
	var node_lifes = get_parent().get_node("HUD/HBoxContainer/ControlLifes")
	connect("change_life", node_lifes, "_on_change_life")
	emit_signal("change_life", max_health)
	position.x = Global.checkopoint_pos + 50	

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.x = 0
	
	if !hurted:
		_get_input()
	
	velocity = move_and_slide(velocity, UP)
	
	_set_animation()
	
	for platforms in get_slide_count():
		var collision = get_slide_collision(platforms)
		if collision.collider.has_method("collide_with"):
			collision.collider.collide_with(collision, self)
  
func _get_input():
	velocity.x = 0
	
	var move_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	velocity.x = lerp(velocity.x, move_speed * move_direction, 0.3)
	
	if move_direction != 0:
		$Sprite.scale.x = move_direction
		knockback_dir = move_direction
		$Particles2D.scale.x = move_direction
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_force / 2

func _set_animation():
	var anim = "idle"
	
	if !is_on_floor():
		anim = "jump"
	elif velocity.x != 0:
		anim = "run"
		$Particles2D.emitting = true
	
	if velocity.y > 0 and !is_on_floor():
		anim = "falling"

	if hurted:
		anim = "hit"
	
	if $AnimationPlayer.assigned_animation != anim :
		$AnimationPlayer.play(anim)

func knockback():
	if $colissions_knockback/left.is_colliding():
		velocity.x = knockback_dir * knockback_intensiy
	elif $colissions_knockback/right.is_colliding():
		velocity.x = -knockback_dir * knockback_intensiy
	velocity = move_and_slide(velocity)
	
func _on_Area2DHurtBox_body_entered(body):
	player_health -= 1
	hurted = true
	emit_signal("change_life", player_health)
	knockback()
	get_node("Area2DHurtBox/CollisionShape2D").set_deferred("disabled", true)
	yield(get_tree().create_timer(0.5),"timeout")
	get_node("Area2DHurtBox/CollisionShape2D").set_deferred("disabled", false)
	hurted = false
	if player_health < 1:
		queue_free()
		get_tree().reload_current_scene()

func hit_checkpoint():
	Global.checkopoint_pos = position.x
