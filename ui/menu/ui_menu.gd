class_name UIMenu extends Control

@onready var button_start: Button = $VBoxContainer/VBoxContainer/button_start

func _ready() -> void:
	button_start.pressed.connect(start)
	GM.state_changed.connect(func(state: GM.State):
		match state:
			GM.State.NONE:
				self.show()
			GM.State.PLAYING:
				self.hide()
	)

func start() -> void:
	GM.state = GM.State.PLAYING
