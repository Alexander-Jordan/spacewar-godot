class_name ThrustAudioStreamPlayer extends AudioStreamPlayer2D

@export var stream_loop: AudioStream
@export var stream_end: AudioStream

func start_thrust() -> void:
	pitch_scale = randf_range(0.8, 1.2)
	stream = stream_loop
	play()

func end_thrust() -> void:
	stream = stream_end
	play()
