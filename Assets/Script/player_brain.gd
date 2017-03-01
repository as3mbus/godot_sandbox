extends RigidBody2D

var player
var feet
var jump_height=500
var move_speed=200
var collided=false
var player2


export var next_level=""

func _ready():
	set_process(true)
	feet=get_node("feet")
	feet.add_exception(self)
	player2=get_parent().get_node("Player2")
	
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	
func _process(delta):
	if !feet.is_colliding():
		collided=false
	if feet.is_colliding()&&!collided:
		collided=true
		print("collide")
	

	
	if (Input.is_action_pressed("ui_up")and feet.is_colliding()):
		set_axis_velocity(Vector2(0,-jump_height))
		
		
	if Input.is_action_pressed("ui_right"):
		set_axis_velocity(Vector2(move_speed,0))
	if Input.is_action_pressed("ui_left"):
		set_axis_velocity(Vector2(-move_speed,0))
	
	if Input.is_key_pressed(KEY_Q):
		get_tree().quit()
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
		
	if player2 in get_colliding_bodies():
		print("collide signal recieved")
		get_tree().change_scene(next_level)