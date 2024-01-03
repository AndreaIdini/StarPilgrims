extends ColorRect

@onready var text = $Text
@onready var button = $Button
@onready var tab_bar = %TabBar


var game_speed
var text_speed = 0.03
var skip = false

func _ready():
	skip = false

func _input(event):
	if event is InputEventMouseButton:
		skip = true
		pass
		
func start_tutorial():
	text_scroll("Hello, welcome to Space Station 1. Don't be startled! We needed to jumpstart the waking process and you might miss many operating parameters. I'm here to provide guidance!", "Roger Roger")
	await button.button_up
	text_scroll("Space Station 1 (S1) is the first station of the Space United Combine (SUC). You are the AI that has to attend to this branch of SUC in the generational effort of making a self-sustaining space environment for human habitation. 
	
	Your final mission is even grander, it will become clear with time.", "Affirmative")

func game_over():
	
	text_scroll("[center]One Human died frozen or hungry despite your best efforts (I hope). 
	Unfortunately this makes you unfit for an AI. Our space exploration program needs better", "")
	

func text_scroll(textScroll, textButton):
	skip = false
	game_speed = tab_bar.current_tab
	tab_bar.current_tab = 0 # pause
	button.hide()
	self.show()
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
		
	button.text = textButton
	button.show()

	skip = false

func _on_button_pressed():
	self.hide() # Replace with function body.
	tab_bar.current_tab = game_speed
