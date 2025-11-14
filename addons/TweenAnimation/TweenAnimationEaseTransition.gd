@tool
class_name TweenAnimationEaseTransition
extends EditorScript

var draw_node: Control

func _run():
	var window = Window.new()
	draw_node = ColorRect.new()
	window.add_child(draw_node)
	draw_node.color = Color.BLACK
	draw_node.draw.connect(_draw_tween)
	var size = _get_position(ease_types.size() * trans_types.size() - 1) + tween_size + Vector2.ONE * border
	draw_node.size = size
	window.title = "Godot Tween Animation Ease Transition"
	window.min_size = size
	window.max_size = size
	window.ready.connect((func(): draw_node.queue_redraw()))
	window.close_requested.connect(window.queue_free)
	EditorInterface.popup_dialog_centered(window)

const trans_types = {
    Tween.TransitionType.TRANS_LINEAR: "LINEAR",
    Tween.TransitionType.TRANS_SINE: "SINE",
    Tween.TransitionType.TRANS_QUINT: "QUINT",
    Tween.TransitionType.TRANS_QUART: "QUART",
    Tween.TransitionType.TRANS_QUAD: "QUAD",
    Tween.TransitionType.TRANS_EXPO: "EXPO",
    Tween.TransitionType.TRANS_ELASTIC: "ELASTIC",
    Tween.TransitionType.TRANS_CUBIC: "CUBIC",
    Tween.TransitionType.TRANS_CIRC: "CIRC",
    Tween.TransitionType.TRANS_BOUNCE: "BOUNCE",
    Tween.TransitionType.TRANS_BACK: "BACK",
    Tween.TransitionType.TRANS_SPRING: "SPRING",
}

const ease_types = {
	Tween.EaseType.EASE_IN: {name = "IN", color = Color.CHARTREUSE},
	Tween.EaseType.EASE_OUT: {name = "OUT", color = Color.CORAL},
	Tween.EaseType.EASE_IN_OUT: {name = "IN_OUT", color = Color.ORCHID},
	Tween.EaseType.EASE_OUT_IN: {name = "OUT_IN", color = Color.BLUE_VIOLET},
}

const border = 40
const tween_size = Vector2(100, 100)

func _get_position(index: int):
	return Vector2(index % 12, index / 12) * (tween_size + Vector2.ONE * border) + Vector2(border, border * 3)
	
func _draw_circle(pos: Vector2, color: Color, text: String = ""):
	draw_node.draw_circle(pos, 5, color)
	if text:
		_draw_string(pos + Vector2(20, 5), text, 20, color)

func _draw_string(pos: Vector2, text: String, font_size: int, color: Color):
	draw_node.draw_string(ThemeDB.fallback_font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, color)

func _draw_tween():
	_draw_string(Vector2(border, border * 2), "Godot Tween Animation Ease Transition", 56, Color.CORNFLOWER_BLUE)
	for ease_type in ease_types.keys():
		_draw_circle(Vector2(_get_position(8 + ease_type).x, border * 2), ease_types[ease_type].color, ease_types[ease_type].name)
	
	var index := 0
	for trans_type in trans_types:
		for ease_type in ease_types:
			var position = _get_position(index)
			
			var points = []
			for i in 100:
				var t = i / (100 - 1.0)
				points.append(position + Vector2(t, Tween.interpolate_value(1.0, -1.0, t, 1, trans_type, ease_type)) * tween_size)
			
			for p in len(points) - 1:
				draw_node.draw_line(points[p], points[p + 1], ease_types[ease_type].color, 2, true)

			if index % 4 == 0:
				_draw_string(position + Vector2(4, 14), trans_types[trans_type], 18, Color.BEIGE)
				
			index += 1