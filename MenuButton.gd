extends MenuButton

@onready var story_box = %StoryBox

func _ready():
	var popup = get_popup()
	#popup.add_item("Save", 0)
	#popup.add_item("Load", 1)
	popup.add_item("About",2)
	popup.add_item("Quit", 3)
	popup.connect("id_pressed", _on_MenuButton_item_selected, 0)


func _on_MenuButton_item_selected(id):
	match id:
		0:
			print("Save Game Selected")
			
		1:
			print("Load Game Selected")
		2:
			story_box.about()
		3:
			print("Quit")
			get_tree().quit()

