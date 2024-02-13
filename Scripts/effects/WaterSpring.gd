extends Node2D

var velocity = 0
var force = 0
var height = 0
var target_height = 0
var k = 0.015
var d = 0.03
var index = 0
var motion_factor = 0.01
signal splash
@onready var collision = $Area2D/CollisionShape2D
func water_update(spring_constant, dampening):
	height = position.y
	var x = height - target_height
	var loss = -dampening *velocity
	force = - spring_constant * x +loss
	velocity +=force
	position.y += velocity
	pass


func initialize(x_position, id):
	height = position.y
	target_height = position.y
	velocity = 0
	position.x = x_position
	index = id

func set_collision_width(value):
	var extents = collision.shape.get_rect()
	var new_extents = Vector2(value/2, extents.size.y)
	collision.shape.set_size(new_extents)
	print(new_extents)


func _on_area_2d_body_entered(body):
	print(body)
	var speed = body.velocity.y * motion_factor
	emit_signal("splash",index,speed)
