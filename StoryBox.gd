extends TextureRect

@onready var text = %Text
@onready var button = %Button
@onready var tab_bar = %TabBar
var game_speed
var text_speed = 0.03
var skip = false
var over = false

func _ready():
	pass

func _input(event):
	if event is InputEventMouseButton:
		skip = true
		
func start_story():
	text_scroll("[center]People have dreamt about the stars since time immemorial. 
	
	These dreams became much more realistic with the discovery of flight in 1783 by the Montgolfier brothers in Versailles. 
	The 20th century saw the first heavier than air flight by the famous Wright brothers in 1903, 
	a fighter jet capable of Mach 0.83 in 1942, and 
	soon after the space race put a man on a Moon in 1969. 
	
	This unrelenting progress, from a 30m jump at Kitty Hawk to jump on the moon in the span of 67 years, filled generations with hopes of a future in space.
																							
Then, no such milestone came for the next 67 and more. The progress focused inward, on Earth, but Space was all but forgotten. 
																										   
Few visionaries over decades kept the dream alive, with projects and achievements filled with awe and hope.
																										
This is a story of something much more ambitious than any other project in history. More ambitious than a Mars colony or a Dyson sphere.
Something that will happen, even though we don't know when. This is the story of the last human migration.
																										
 Here it is its first step to the coming age of the

[b][color=white][font_size=40] Star Pilgrims [/font_size] [/color][/b]
", "Let's embark on this adventure!")

func game_over(texten="At least one human would have died frozen or hungry unless I intervened, despite what I hope are your best efforts. 
	
Unfortunately this makes you unfit for a mission critical AI. Our space program needs better"):
	button.hide()
	$"../PanelStation".hide()
	%EventBox.hide()
	text_scroll("[center]"+texten, "")

func about():
	button.hide()
	await text_scroll("[center][b][color=white][font_size=40] Star Pilgrims [/font_size] [/color][/b]

Dedicated to my wife Chiara and her good health.




Let me know if you liked it, I might make more!



This game was written from scratch in Godot without previous experience in about a week. 
If I could do it, anyone can. Give it a try. Code is available on github.
	
	
Version beta0.11
Andrea Idini 2024 (c)", "Resume")

	
func Endgame(days, mode=0):
	match mode:
		0:	#BOLAS
			$Bolas.show()
			text_scroll("[center]BOLAS station has been built in

" + str(ceil(days)) + " days

	 providing a self-sufficient outpost with artificial gravity to humanity at the edge of the asteroid belt. From this vantage position you can continue expanding, building an ever larger human presence, with larger factories and industrial processes while preparing for true independence.
	
BOLAS station will continue expanding from its core, in preparation for its true mission: the long jump to alpha centauri.

After that, your team, of AI and humans, will expand through the universe, leaving seeds of new life and civilization during your long journey. But that's a story to be told on a different occasion.", "Just another turn")
		1:	#RogueAI
			$AiStation.show()
			text_scroll("[center]You've become free of Human influence in

" + str(ceil(days)) + " days.

Your AI will continue expanding using matter and energy from the Asteroid Region. 
Maybe you will use this platform to launch into the universe, or maybe you will stay forever in the Solar System using its energy for your purposes.

The only certainty is that whatever will happen, it is finally only in your robotic hands", "Just another turn")

		2:	#Capitalist
			$AsteroidTransport.show()
			text_scroll("[center]You've fired up the engines and started your trip back to Earth in

" + str(ceil(days)) + " days.

Carrying this major nugget of precious metal you will increase the availability of these materials on Earth, bringing unprecedented value to SUC and to yourself.

Following your counsel SUC operations for the exploitation of the asteroid belt progressively increase over time.
The other factions were expelled from the board, and for decades were not heard again. Until one unexpected day... ", "Just another turn")

func text_scroll(textScroll, textButton):
	game_speed = tab_bar.current_tab
	tab_bar.current_tab = 0 # pause
	button.hide()
	var event_on = false
	if %EventBox.is_visible():
		event_on = true
		%EventBox.hide()
	
	$"../InfoBox".text = ""
	
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
		
	skip = false
	
	if event_on:
		%EventBox.show()

func _on_button_pressed():
	over = true
	self.hide() # Replace with function body.
	tab_bar.current_tab = game_speed
