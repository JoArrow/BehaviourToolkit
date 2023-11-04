@tool
extends EditorPlugin


var _ui_canvas: Control
var _ui_spatial: Control


var _toolkit_ui = preload("res://addons/behaviour_toolkit/ui/toolkit_ui.tscn")


func _enter_tree():
    _ui_canvas = _toolkit_ui.instantiate()
    _ui_spatial = _toolkit_ui.instantiate()

    add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_SIDE_LEFT,_ui_canvas)
    _ui_canvas.visible = false
    add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_LEFT, _ui_spatial)
    _ui_spatial.visible = false

    # Connect editor signals 
    get_editor_interface().get_selection().selection_changed.connect(_on_selection_changed)



func _exit_tree():
    remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_SIDE_LEFT,_ui_canvas)
    remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_LEFT, _ui_spatial)

    _ui_canvas.queue_free()
    _ui_spatial.queue_free()


func _on_selection_changed() -> void:

	# Get current selection
    var selection = get_editor_interface().get_selection().get_selected_nodes()

    if selection.size() == 0:
        _ui_canvas.visible = false
        _ui_spatial.visible = false
        return
    
    _ui_canvas.set_current_selection(selection[0])
    _ui_spatial.set_current_selection(selection[0])

    for node in selection:
        if node is BehaviourToolkit:
            _ui_canvas.visible = true
            _ui_spatial.visible = true
            return

    _ui_canvas.visible = false
    _ui_spatial.visible = false            