class_name Torpedo extends Spawnable2D

@export var audio_stream_launch: AudioStream
@export var speed: int = 500

@onready var destructor_2d: Destructor2D = $Destructor2D
@onready var random_audio_player_2d: RandomAudioPlayer2D = $RandomAudioPlayer2D
@onready var timer: Timer = $Timer

func _process(delta: float) -> void:
	root_node.position += direction.normalized() * speed * delta

func _ready() -> void:
	destructor_2d.destructed.connect(func():
		random_audio_player_2d.play_random_audio_and_await_finished(destructor_2d.audio_streams_destruct)
	)
	destructor_2d.destroyed.connect(func():
		random_audio_player_2d.play_random_audio_and_await_finished(destructor_2d.audio_streams_destroyed)
		call_deferred('despawn')
	)
	spawned.connect(func(_spawn_point: Vector2):
		if audio_stream_launch != null:
			random_audio_player_2d.play_random_audio_and_await_finished([audio_stream_launch])
		timer.start()
	)
	timer.timeout.connect(func(): call_deferred('despawn'))
