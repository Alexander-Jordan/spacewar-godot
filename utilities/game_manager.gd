class_name GameManager extends Node

enum State {
	NONE,
	P1_WIN,
	P2_WIN,
	PLAYING,
}

var lives_p1: int = 3:
	set(l):
		if l < 0 or l == lives_p1 or state != State.PLAYING:
			return
		lives_p1 = l
		lives_p1_changed.emit(l)
		if l == 0:
			state = State.P2_WIN
var lives_p2: int = 3:
	set(l):
		if l < 0 or l == lives_p2 or state != State.PLAYING:
			return
		lives_p2 = l
		lives_p2_changed.emit(l)
		if l == 0:
			state = State.P1_WIN
var state: State = State.NONE:
	set(s):
		if !State.values().has(s) or s == state:
			return
		state = s
		state_changed.emit(state)
		if s == State.PLAYING:
			lives_p1 = 3
			lives_p2 = 3

signal lives_p1_changed(lives: int)
signal lives_p2_changed(lives: int)
signal state_changed(state: State)
