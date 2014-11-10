
extends KinematicBody2D

const speed = 200  # pixel/second

var direction = Vector2(0, 1)
var score = 0

var music
var sounds
var background_btn
var clown_btn
var score_label


func start_run(speed_delta):
	var phi = deg2rad(randi() % 361)
	direction = direction.rotated(phi)
	speed += speed_delta
	var rand_x = randi() % 600 + 100
	var rand_y = randi() % 300 + 100
	set_pos(Vector2(rand_x, rand_y))


func _fixed_process(delta):
	var motion = Vector2()
	motion = direction * speed * delta
	move(motion)
	
	if is_colliding():
		var n = get_collision_normal()
		direction = n.reflect(direction)
		motion = direction * speed * delta
		move(motion)


func _on_background_pressed():
	sounds.play("bounce")


func _on_clown_pressed():
	sounds.play("click")
	score += 1
	score_label.set_text("Your score: " + str(score))
	start_run(20)


func _ready():
	var game = get_node("/root/game")
	music = game.get_node("music")
	music.play()
	sounds = game.get_node("sounds")
	background_btn = game.get_node("background_btn")
	background_btn.connect("pressed", self, "_on_background_pressed")
	clown_btn = get_node("clown_btn")
	clown_btn.connect("pressed", self, "_on_clown_pressed")
	score_label = game.get_node("score_label")
	start_run(0)
	set_fixed_process(true)
