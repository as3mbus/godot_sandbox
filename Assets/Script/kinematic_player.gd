extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var direction = Vector2(0,0) #direction to move
var moving = false #is moving
var startPos = Vector2(0,0) #starting pos before moving

var canMove=true
var pressed=false

const speed = 2 #speed of movement factors of the grid
const grid = 32 #grid size

var world #detecting collision

var sprite
var animationPlayer

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	set_process_input(true)
	
	world=get_world_2d().get_direct_space_state()
	
	sprite=get_node("Sprite")
	animationPlayer=get_node("AnimationPlayer")
	
	
	
func _input(event):
	if event.is_action_pressed("ui_interact"):
		pressed=true
	elif event.is_action_released("ui_interact"):
		pressed=false

func _fixed_process(delta):
	if !moving and canMove:
		var resultUp=world.intersect_point(get_pos() + Vector2 (0,-grid)) #collision detection
		var resultDown=world.intersect_point(get_pos() + Vector2 (0,grid))
		var resultLeft=world.intersect_point(get_pos() + Vector2 (-grid,0))
		var resultRight=world.intersect_point(get_pos() + Vector2 (grid,0))
		if Input.is_action_pressed("ui_up") and !moving:
			sprite.set_frame(0)
			if resultUp.empty():
				moving=true
				direction=Vector2(0,-1)
				startPos=get_pos()
				animationPlayer.play("walk_up")
		if Input.is_action_pressed("ui_down") and !moving:
			sprite.set_frame(6)
			if resultDown.empty():
				moving=true
				direction=Vector2(0,1)
				startPos=get_pos()
				animationPlayer.play("walk_down")
		if Input.is_action_pressed("ui_left")and !moving :
			sprite.set_frame(3)
			if resultLeft.empty():
				moving=true;
				direction=Vector2(-1,0)
				startPos=get_pos()
				animationPlayer.play("walk_left")
		if Input.is_action_pressed("ui_right")and !moving:
			sprite.set_frame(9)
			if resultRight.empty():
				moving=true;
				direction=Vector2(1,0)
				startPos=get_pos()
				animationPlayer.play("walk_right")
		if pressed: #Input.is_action_pressed("ui_interact"):
			if sprite.get_frame()==0 :
				interact(resultUp)
			elif sprite.get_frame()==6 :
				interact(resultDown)
			elif sprite.get_frame()==3 :
				interact(resultLeft)
			elif sprite.get_frame()==9 :
				interact(resultRight)
	elif canMove :
		move_to(get_pos()+direction*speed);
		if get_pos()==startPos+Vector2(grid*direction.x, grid*direction.y):
			moving=false
	pressed=false

func interact(result):
	
	for dictionary in result:
		if typeof(dictionary.collider) == TYPE_OBJECT and dictionary.collider.has_node("interact"):
			print("interact");
			get_parent().get_node("Camera2D/Patch9Frame").set_hidden(false)
			get_parent().get_node("Camera2D/Patch9Frame").print_dialogue(dictionary.collider.get_node("interact").text)