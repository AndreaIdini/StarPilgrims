extends MenuButton

@onready var story_box = %StoryBox

func _ready():
	var popup = get_popup()

	popup.add_item("About",0)
	popup.add_item("Mute", 1)
	popup.add_item("Resume", 2)
	#popup.add_item("Save", 2)
	#popup.add_item("Load", 3)
	popup.add_item("Quit", 4)
	popup.connect("id_pressed", _on_MenuButton_item_selected, 0)


func _on_MenuButton_item_selected(id):
	match id:
		0:
			story_box.about()
		1:
			if(self.get_popup().get_item_text(1) == "Mute"):
				$"../AudioStreamPlayer".stop()
				self.get_popup().set_item_text(1, "Unmute")
			elif(self.get_popup().get_item_text(1) == "Unmute"):
				$"../AudioStreamPlayer".play()
				self.get_popup().set_item_text(1, "Mute")
		2:
			%TabBar.current_tab = 1
		4:
			print("Quit")
			get_tree().quit()

