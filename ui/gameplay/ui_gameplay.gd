class_name UIGameplay extends Control

@onready var button_restart: Button = $VBoxContainer/VBoxContainer/button_restart
@onready var label_lives_p1: Label = $VBoxContainer/HBoxContainer/label_lives_p1
@onready var label_lives_p2: Label = $VBoxContainer/HBoxContainer/label_lives_p2
@onready var label_result: Label = $VBoxContainer/VBoxContainer/label_result
@onready var v_box_container: VBoxContainer = $VBoxContainer/VBoxContainer

func _ready() -> void:
	button_restart.pressed.connect(func(): GM.state = GM.State.PLAYING)
	GM.lives_p1_changed.connect(func(lives: int): label_lives_p1.text = str(lives))
	GM.lives_p2_changed.connect(func(lives: int): label_lives_p2.text = str(lives))
	GM.state_changed.connect(func(state: GM.State):
		match state:
			GM.State.P1_WIN:
				show_result('PLAYER 1 WINS!')
			GM.State.P2_WIN:
				show_result('PLAYER 2 WINS!')
			GM.State.NONE:
				v_box_container.hide()
				self.hide()
			GM.State.PLAYING:
				v_box_container.hide()
				self.show()
	)

func show_result(text: String) -> void:
	label_result.text = text
	v_box_container.show()
