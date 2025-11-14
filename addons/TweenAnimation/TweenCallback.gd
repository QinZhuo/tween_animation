@tool
class_name TweenCallback extends TweenAnimation

signal callback

func create_tweenr(root_tween: Tween, is_play_back: bool = false):
	root_tween.tween_callback(callback.emit)
	super.create_tweenr(root_tween, is_play_back)
