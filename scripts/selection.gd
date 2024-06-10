extends Node2D

var drag_start = Vector2.ZERO
var select_rect = RectangleShape2D.new()
var selected = []
var dragging = false

func compute_selected_units(start, end, space, filter_function=null):
	var result
	var query = PhysicsShapeQueryParameters2D.new()
	select_rect.extents = abs(end - start) / 2
	query.shape = select_rect
	query.collision_mask = 2
	query.transform = Transform2D(0, (end + start) / 2)
	if filter_function:
		result = space.intersect_shape(query, 100).filter(filter_function)
	else:
		result = space.intersect_shape(query)
	return result

func set_start_dragging(pos):
	dragging = true
	drag_start = pos

func set_stop_dragging(stop, space, filter_func):
	dragging = false
	selected = compute_selected_units(drag_start, stop, space, filter_func)
	set_selected_units(true)

func set_selected_units(status):
	for unit in selected:
		if is_instance_valid(unit.collider):
			unit.collider.set_selected(status)

func set_selected(value):
	selected = value

func set_selected_unit_target_entity(entity, tilemap):
	set_selected_unit_target_position(entity.position, tilemap)

func set_selected_unit_target_position(event_pos, tilemap):
	#var field = calculate_flow_field(tilemap, event_pos)
	#var flow_field = field
	var field = tilemap.compute_navigation(event_pos, selected)
	for unit in selected:
		if is_instance_valid(unit.collider):
			unit.collider.set_flow_field(field, tilemap)
			unit.collider.set_target_position(event_pos, selected)
