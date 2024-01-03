extends ColorRect

@onready var text = $Text
@onready var button = $Button
@onready var tab_bar = %TabBar
@onready var arrow = $Arrow
@onready var station = $"../PanelStation"



var game_speed
var text_speed = 0.03
var skip = false
var mouseIn = false
var nextDialog = false

func _ready():
	arrow.hide()
	skip = false 


func _input(event):
	if event is InputEventMouseButton and mouseIn:
		if event.button_index == 1: # if leftclick
			skip = true
		
func start_tutorial():
	
	game_speed = tab_bar.current_tab
	tab_bar.current_tab = 0 # pause
	#text_scroll("Hello, welcome to Space Station 1. Don't be startled! We needed to jumpstart the waking process and you might miss many operating parameters. 
#I'm here to provide guidance!", "Roger Roger")
	#await button.button_up
	#
	#text_scroll("Space Station 1 (S1) is the first station of the Space United Combine (SUC).
#You are the AI that has to attend to this branch of SUC in the generational effort of making a self-sustaining space environment for human habitation. 
	#
#Your final mission is even grander, it will become clear with time.", "Affirmative")
	#await button.button_up

	#await text_scroll("We need to work on your attitude in the future to better serve our humans... 
#...In the meantime, the basics:
#
#There are three resources for you to control", "")
	#await text_scroll("- [u]Energy[/u]. 
#We produce it with power and store it with batteries. 
#Basically everything costs energy up here. Beware of keeping a healthy energy balance!", "")
	#await text_scroll("- [u]Matter[/u]. 
#For now you'll need to pay credits for matter to be delivered from Earth, but we need to think of a better way to satisfy the basic needs.", "")
	#await text_scroll("- [u]Credits[/u]. 
#Right now you need credits to order launches, and expand. You can obtain credits hosting humans and providing other services.", "")
	#await text_scroll("[u]Your primary directive is[/u]
#to have a positive balance of all the three resources at all times.", "")
	#await text_scroll("
#If the energy goes to 0, the human freezes.", "")
	#await text_scroll("
#If the matter goes to 0, the human hungers.", "")
	#await text_scroll("
#If the credits go to 0 while the human suffers and you cannot afford a rescue mission, the human dies.", "")
	#text_scroll("If the human dies, you failed your purpose as an AI and you will be replaced.
#So be a good AI and make sure there's always enough energy, matter and credits to go around. Understood?","Understood.")
	#await button.button_up
	
	text_scroll("Your first objective now is to start populating this space station.
First, you will have to launch some matter to preparare for the human arrival.
Select the amount of matter to order and launch!","Will do!")
	await button.button_up
	self.hide()
	
	if station.matter > 0.01:
		print("here we are")
	
	tab_bar.current_tab = 1 # play
func game_over():
	
	text_scroll("[center]One Human died frozen or hungry despite your best efforts (I hope). 
	Unfortunately this makes you unfit for an AI. Our space exploration program needs better", "")
	

func text_scroll(textScroll, textButton):
	skip = false
	arrow.hide()
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
	
	if textButton != "":
		button.text = textButton
		button.show()
	else:
		arrow.show()
		nextDialog = true
		await get_tree().create_timer(0.2).timeout
		skip = false
		while true:
			await get_tree().create_timer(0.2).timeout
			if skip:
				return
		
	skip = false

func _on_button_pressed():
	self.hide() # Replace with function body.
	tab_bar.current_tab = game_speed


func _on_mouse_entered():
	mouseIn=true # Replace with function body.


func _on_mouse_exited():
	if not Rect2(Vector2(), size).has_point(get_local_mouse_position()): # workaround to not leave when hovering on text
		mouseIn=false # Replace with function body.
