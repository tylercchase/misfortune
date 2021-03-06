extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Fireball = preload("res://player/fireball.tscn")

signal hit
var counter = 1
export var speed = 400
var health = 2
var screen_size
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()


	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		pass
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_just_pressed("click"):
		if counter == 0:
			shoot()
		else:
			counter -= 1
	if velocity.length() > 0:
        velocity = velocity.normalized() * speed
        $AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	move_and_collide(velocity * delta)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		
		if velocity.y > 0:
			$AnimatedSprite.animation = "down"
		else:
			$AnimatedSprite.animation = "up"
	pass


func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$hitbox.set_deferred("disabled",true)

func hit():
	if health == 0:
		hide()
		emit_signal("hit")
		$hitbox.set_deferred("disabled",true)
	else:
		health -= 1
	
func start(pos):
	position = pos
	show()
	
func shoot():
    # "Muzzle" is a Position2D placed at the barrel of the gun.
	var dir = get_global_mouse_position() - global_position
	var b = Fireball.instance()
	b.start($Wand.global_position, dir.angle())
	get_parent().add_child(b)