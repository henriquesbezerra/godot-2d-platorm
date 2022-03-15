extends Control

var life_sizes = 32

func _on_change_life(health):
	$LifesSprite.rect_size.x = health * life_sizes
	$LifesSprite.rect_size.y = 32
