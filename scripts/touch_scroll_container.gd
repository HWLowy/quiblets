class_name TouchScrollContainer
extends ScrollContainer

# ScrollContainer already supports wheels and trackpads well. This small layer
# adds reliable one-finger scrolling on iPad, even when a button or draggable
# card fills the viewport, and keeps the thin native bars out of the way.
const AXIS_VERTICAL := 0
const AXIS_HORIZONTAL := 1
const TOUCH_DEADZONE := 12.0
const DIRECTION_BIAS := 1.15
const INERTIA_DECELERATION := 2600.0

var touch_axis := AXIS_VERTICAL
var active_touch := -1
var touch_origin := Vector2.ZERO
var touch_scrolling := false
var suppress_emulated_release := false
var inertia_velocity := 0.0

func configure(axis: int, name_hint: String) -> TouchScrollContainer:
	touch_axis = axis
	name = name_hint
	apply_scroll_settings()
	return self

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	apply_scroll_settings()
	set_process(false)

func apply_scroll_settings() -> void:
	scroll_deadzone = int(TOUCH_DEADZONE)
	horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER if touch_axis == AXIS_HORIZONTAL else ScrollContainer.SCROLL_MODE_DISABLED
	vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER if touch_axis == AXIS_VERTICAL else ScrollContainer.SCROLL_MODE_DISABLED

func _input(event: InputEvent) -> void:
	if not is_visible_in_tree() or get_viewport() == null:
		return
	if event is InputEventScreenTouch:
		if event.pressed:
			if active_touch == -1 and get_global_rect().has_point(event.position):
				active_touch = event.index
				touch_origin = event.position
				touch_scrolling = false
				suppress_emulated_release = false
				inertia_velocity = 0.0
				set_process(false)
		elif event.index == active_touch:
			if touch_scrolling:
				suppress_emulated_release = true
				get_viewport().set_input_as_handled()
				notify_scroll_children(Control.NOTIFICATION_SCROLL_END)
				set_process(absf(inertia_velocity) > 1.0)
			active_touch = -1
			touch_scrolling = false
			call_deferred("clear_release_guard")
	elif event is InputEventScreenDrag and event.index == active_touch:
		var movement: Vector2 = event.position - touch_origin
		var intended: float = absf(movement.x) if touch_axis == AXIS_HORIZONTAL else absf(movement.y)
		var across: float = absf(movement.y) if touch_axis == AXIS_HORIZONTAL else absf(movement.x)
		if not touch_scrolling:
			if intended < TOUCH_DEADZONE or intended < across * DIRECTION_BIAS or not has_scroll_range():
				return
			touch_scrolling = true
			notify_scroll_children(Control.NOTIFICATION_SCROLL_BEGIN)
		var relative_axis: float = event.relative.x if touch_axis == AXIS_HORIZONTAL else event.relative.y
		var velocity_axis: float = event.velocity.x if touch_axis == AXIS_HORIZONTAL else event.velocity.y
		move_scroll(-relative_axis)
		inertia_velocity = -velocity_axis
		get_viewport().set_input_as_handled()

func _process(delta: float) -> void:
	if active_touch != -1 or absf(inertia_velocity) <= 1.0:
		inertia_velocity = 0.0
		set_process(false)
		return
	var before := current_scroll()
	move_scroll(inertia_velocity * delta)
	if is_equal_approx(before, current_scroll()):
		inertia_velocity = 0.0
	else:
		inertia_velocity = move_toward(inertia_velocity, 0.0, INERTIA_DECELERATION * delta)

func has_scroll_range() -> bool:
	var bar: ScrollBar = get_h_scroll_bar() if touch_axis == AXIS_HORIZONTAL else get_v_scroll_bar()
	return bar.max_value - bar.page > 1.0

func current_scroll() -> float:
	return float(scroll_horizontal if touch_axis == AXIS_HORIZONTAL else scroll_vertical)

func move_scroll(amount: float) -> void:
	if touch_axis == AXIS_HORIZONTAL:
		scroll_horizontal += roundi(amount)
	else:
		scroll_vertical += roundi(amount)

func notify_scroll_children(notification: int) -> void:
	for child in get_children():
		child.propagate_notification(notification)

func is_suppressing_tap() -> bool:
	return touch_scrolling or suppress_emulated_release

func clear_release_guard() -> void:
	suppress_emulated_release = false
