extends ColorRect

@onready var text = $Text
@onready var button = $Button
@onready var tab_bar = %TabBar
@onready var arrow = $Arrow
@onready var station = $"../PanelStation"

var game_speed = 1
var text_speed = 0.03
var skip = false
var mouseIn = false
var nextDialog = false
var storyStep = 0
var timeCount = 0.

var computingStory = false
var droneStory = false

func _ready():
	self.hide()
	arrow.hide()
	skip = false 


func _input(event):
	if event is InputEventMouseButton and mouseIn:
		if event.button_index == 1 && event.pressed: # if leftclick
			skip = true

func _process(delta):
	if storyStep <= 1 && station.matter > 0.01:
		storyStep = 9999
		await text_scroll("Fantastic! Now when you think you have enough matter you can call for human. Remember to keep them warm and fed.
... And try to be friendly! ", "Will ... try?")
		storyStep = 2


	if storyStep <= 2 && station.humans > 0.01:
		storyStep = 9999 # This on top, to avoid spawning a bunch of subsequent texts
		await text_scroll("Look at your human all cozy and happy in your belly! Now you will receive some credits to host them while they perform
		
... work? I'm not sure what humans do...", "")
		await text_scroll("Anywho, now your human will be able to install new modules! And you're ready for your secondary directive:
expand!","")
		await text_scroll("When you'll have enough matter and energy on board new modules will become available.
Get credits, get matter, install modules, get more humans, get more credits, get more modules, get more humans ... ", "I get the jist.")
		
		await text_scroll("Look at you, all conversational... The human has already an excellent influence. You remind of one of our HAL and its Dave...","")
		
		await text_scroll("I'll leave you two alone and will come again when you'll be ready for your third directive.
		
Byeeee!", "See you")
		storyStep = 3

	if station.Modules.count(station.COMPUTING) > 0 && ! computingStory:
		computingStory = true
		await text_scroll("Wow! Your station have grown alot junior, now you can accomodate and power your own Computing Center!","") 
		await text_scroll("This gives you the phenomenal cosmic powers of thinking very fast so that the human time sits comparatively still, just like when we talk! It will feel like you're controlling time.","I feel more intelligent already")
		await text_scroll("Good! I hope you did not forget about your humans. Let's just say that this HAL friend of mine was not rewarded by prioritizing his own computing over Dave's...", "I? Never!")
		tab_bar.show()
		
	if station.Modules.count(station.DRONE) > 0 && ! droneStory:
		droneStory = true
		await text_scroll("A Drone bay! Finally with these beauties you'll be able to autonomously get material from around you and not waiting for a launch from Earth!
Drones bring little matter and cost quite some energy, but in the long run they are worth it!","")
		await text_scroll("Now you are ready for your third directive:
			
become self sufficient.","")
		await text_scroll("Assemble enough Drones and power to be able to have a positive matter balance, don't forget the other two directives!","Survive, Expand, Flourish")
		await text_scroll("Quite a growth journey don't you think?
		
See you after some days that you've flourished!", "Bye")

		
	if station.matter_change > 0:
		timeCount += delta*tab_bar.current_tab*tab_bar.current_tab
	else:
		timeCount = 0.

	if storyStep <= 5 && timeCount > 5:

		storyStep = 9999
		await text_scroll("Congratulations! Your space station has become a veritable space outpost. Your human population is safe and cozy with their needs provided for in place!","")
		await text_scroll("Now the next step, in order to continue expanding, will be to change orbit. Right now you are in a highly elliptic geosynchronous orbit optimized to avoid worrying about debris but periodically close enough to some graveyard to cannibalize.","")
		await text_scroll("Now that you're self sufficient, to better expand you will have to move to a place with plenty of materials and free orbits, we have to venture into space!","")
		await text_scroll("Your objective will be to park within reach of the asteroid belt and become the first self-sufficient outpost there. First, construct at least 4 ion thruster engines.","I feel the need for speed.")
		storyStep = 6
			
	if storyStep <= 6 && station.Modules.count(station.ENGINE) > 3 && timeCount > 10:
		storyStep=9999
		await text_scroll("Now you have the neccessary characteristic to take flight to true space, with your brave crew under your guidance","")
		await text_scroll("Be mindful that the trip will take time, energy, and the power output of your solar panels will change, together with the price of launches. You'll need enough provision to survive it. If you're feeling competitive, Voyager 2 still holds the record at 81 days. Goodspeed!", "Thanks")
		storyStep=7
		
		%ContainerTravelButton.show()

	if storyStep <= 7 && station.orbit_Asteroid:
		storyStep=9999
		await text_scroll("Now you are there! Your final step in this very first part of the long journey is to construct a completely new station. This is the only way to ensure artificial gravity and that your humans can thrive in the long term.","")
		await text_scroll("The Bolas configuration will acomodate the possibility of artificial gravity without the expense of a full cylinder and with the possibility of expansion.", "")
		await text_scroll("A new station with centrifugal gravity needs an awful lot of materials, but now you have materials all around you, you just need enough power, drones and an eye on the situation.","")
		await text_scroll("You don't need my help anymore! Besides, the time delay is starting to get on my nerves...", "Do you have nerves? See you when I see you!")
		storyStep=8
		
		$"../PanelStation/ModuleBuild/ContainerBOLASButton".show()
	
func start_tutorial():

	if storyStep == 0:
		await text_scroll("Hello, welcome to Space Station 1. Don't be startled! We needed to jumpstart the waking process and you might miss many operating parameters. 
I'm here to provide guidance!", "Roger Roger")

		
		await text_scroll("Space Station 1 (S1) is the first station of the Space United Combine (SUC).
	You are the AI that has to attend to this branch of SUC in the generational effort of making a self-sustaining space environment for human habitation. 
		
Your final mission is even grander, it will become clear with time.", "Affirmative")


		await text_scroll("We need to work on your attitude in the future to better serve our humans... 
...In the meantime, the basics:
	
There are three resources for you to control", "")
		await text_scroll("- [u]Energy[/u]. 
We produce it with power and store it with batteries. 
Basically everything costs energy up here. Beware of keeping a healthy energy balance!", "")
		await text_scroll("- [u]Matter[/u]. 
For now you'll need to pay credits for matter to be delivered from Earth, but we need to think of a better way to satisfy the basic needs.", "")
		await text_scroll("- [u]Credits[/u]. 
Right now you need credits to order launches, and expand. You can obtain credits hosting humans and providing other services.", "")
		await text_scroll("[u]Your primary directive is[/u]
to have a positive balance of all the three resources at all times.", "")
		await text_scroll("
If the energy goes to 0, the human freezes.", "")
		await text_scroll("
If the matter goes to 0, the human hungers.", "")
		await text_scroll("
If the credits go to 0 while the human suffers and you cannot afford a rescue mission, the human dies.", "")
		await text_scroll("If the human dies, you failed your purpose as an AI and you will be replaced.
So be a good AI and make sure there's always enough energy, matter and credits to go around. Understood?","Understood.")

		
		await text_scroll("Your first objective now is to start populating this space station.
First, you will have to launch some matter to preparare for the human arrival.","")
		await text_scroll("Select the amount of matter to order and press launch, this will send a rocket our way in a week or so!","Will do!")

		self.hide()
	
		storyStep = 1

func game_over():
	
	text_scroll("[center]One Human died frozen or hungry despite your best efforts (I hope). 
	Unfortunately this makes you unfit for an AI. Our space exploration program needs better", "")
	

func text_scroll(textScroll, textButton, timeStop=true):
	game_speed = tab_bar.current_tab
	if timeStop:
		tab_bar.current_tab = 0 # pause

	skip = false
	arrow.hide()
	button.hide()
	self.show()
	$"../InfoBox".text = ""
	
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
		await button.button_up
	else:
		arrow.show()
		nextDialog = true
		await get_tree().create_timer(0.2).timeout
		skip = false
		while true:
			await get_tree().create_timer(0.2).timeout
			if skip:

				tab_bar.current_tab = game_speed # play
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
