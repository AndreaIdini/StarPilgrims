extends ColorRect

@onready var tab_bar = %TabBar
@onready var text = $Text
var text_speed = 0.03

var eventTimeCount = 0.
var eventStep = 0

var skip = false
var mouseIn = false
var curiosities = JSON.new()

var curiosityBox = true

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	
	var file = FileAccess.open("res://Asset/curiosities.json", FileAccess.READ)
	var json_text = file.get_as_text()
	curiosities = JSON.parse_string(json_text)

	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):

	eventTimeCount += delta*tab_bar.current_tab*tab_bar.current_tab
	if %EventBox.storyStep > 2 && eventTimeCount > 120:
		var event = randi_range(0,300)
		if event == 0 and eventStep > -1 and curiosityBox:
			curiosity_events()

func curiosity_events():
	eventTimeCount = 0.
	curiosityBox = false
	await text_scroll(curiosities[eventStep]["text"])
	eventStep = abs(eventStep) + 1
	curiosityBox = true
	
	if eventStep >= len(curiosities):
		curiosityBox = false

	

func text_scroll(textScroll, timeStop=false):
	var game_speed = tab_bar.current_tab	
	if timeStop:
		tab_bar.current_tab = 0 # pause
	skip = false
	
	$Button.hide()
	self.show()
	%CuriosityBox.show()
	
	$"../InfoBox".text = ""
	print("here")
	text.bbcode_text = textScroll
	text.visible_characters = 0
	text.set_scroll_follow(true)
	
	while text.visible_characters < len(text.text):
		if !skip:
			text.visible_characters += 1
			await get_tree().create_timer(text_speed).timeout
		else:
			text.visible_characters = len(text.text)
		
	if !skip:
		await get_tree().create_timer(0.3).timeout
	
	await get_tree().create_timer(0.2).timeout
	skip = false
	
	while true:
		await get_tree().create_timer(0.2).timeout
		if skip:
			tab_bar.current_tab = game_speed # play
			self.hide()
			skip = false
			mouseIn = false
			return

		
	skip = false

func _input(event):
	if event is InputEventMouseButton and mouseIn:
		if event.button_index == 1 && event.pressed: # if leftclick
			skip = true

func _on_mouse_entered():
	mouseIn=true # Replace with function body.


func _on_mouse_exited():
	if not Rect2(Vector2(), size).has_point(get_local_mouse_position()): # workaround to not leave when hovering on text
		mouseIn=false # Replace with function body.


func _on_button_pressed():
	self.hide() # Replace with function body.
