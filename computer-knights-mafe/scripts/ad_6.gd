extends Node2D

var speed = randf_range(100, 150)
var areas = []

func _process(delta):
	position.y += speed * delta
	if position.y > 681:
		queue_free()


func _on_ads_area_entered(area: Area2D) -> void:
	if area.is_in_group("espada"):
		Global.count += 1
		$Sprite2D.visible = false
		
