@tool
@icon("res://addons/TweenAnimation/icon.png")
class_name TweenAnimation extends Node

@export_tool_button("Play Test") var play_test_button := func():
	await play().finished
	await get_tree().create_timer(1).timeout
	await playback().finished

@export_group("Child Tween")
@export var is_parallel: bool

var cur_tween: Tween

func _process(delta):
	if Engine.is_editor_hint():
		if cur_tween and cur_tween.is_running():
			cur_tween.custom_step(delta)

func play() -> Tween:
	if cur_tween and cur_tween.is_running():
		cur_tween.kill()
	cur_tween = create_tween()
	create_tweenr(cur_tween)
	return cur_tween

func playback():
	if cur_tween and cur_tween.is_running():
		cur_tween.kill()
	cur_tween = create_tween()
	create_tweenr(cur_tween, true)
	return cur_tween

func create_tweenr(tween: Tween, is_play_back: bool = false):
	var child_count = get_child_count()
	if child_count == 0: return
	var index_array = range(0, child_count) if not is_play_back else range(child_count - 1, -1, -1)
	var subtween = create_tween()
	tween.tween_subtween(subtween)
	subtween.set_parallel(is_parallel)
	for index in index_array:
		var child_tween: TweenAnimation = get_child(index)
		child_tween.create_tweenr(subtween, is_play_back)

func _to_string():
	return "TweenAnimation"
