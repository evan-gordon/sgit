extends VBoxContainer

var text_row = preload("res://text_row.tscn")
var last_event_type = ""
var last_event_val = ""
@onready var scroll_container = $".."
var scrollbar: VScrollBar

func _ready():
	scrollbar = scroll_container.get_v_scroll_bar()
	scrollbar.connect("changed", _on_scrollbar_changed)

func _input(event):
	if not event is InputEventMouseButton:
		return
	var event_data = parse_event(event)
	if event_data[1] != last_event_val:
		last_event_type = event_data[0]
		last_event_val = event_data[1]
		var new_instance = text_row.instantiate()
		new_instance.get_child(0).text = event_data[0] + " " + event_data[1]
		add_child(new_instance)

func _unhandled_input(event):
	var event_data = parse_event(event)
	# Assume new event.
	var new_event = false
	# Todo, it the type is the same i could prune the latest value and add a new one
	# with the updated value.
	if event is InputEventMouseMotion or \
		event is InputEventMouseMotion or \
		event is InputEventScreenTouch:
			new_event = true
	if event_data[0] != last_event_type or \
		event_data[1] != last_event_val:
		new_event = true

	if new_event:
		last_event_type = event_data[0]
		last_event_val = event_data[1]
		var new_instance = text_row.instantiate()
		new_instance.get_child(0).text = event_data[0] + " " + event_data[1]
		add_child(new_instance)



func _on_scrollbar_changed():
	scrollbar.value = scrollbar.max_value

func parse_event(event) -> Array:
	var c = event.get_class()
	if event is InputEventKey:
		return [c, "Key:" + event.as_text_key_label()]
	if event is InputEventMouseButton:
		return [c, "Button_Index:" + str(event.button_index)]
	if event is InputEventMouseMotion:
		return [c, str(event.velocity)]
	if event is InputEventJoypadButton:
		return [c, "Axis:" + str(event.axis) + " Value:" + str(event.axis_value)]
	if event is InputEventJoypadMotion:
		return [c, str(event.button_index)]
	if event is InputEventScreenTouch:
		return [c, str(event.position)]
	return [c, "Unhandled input"]
