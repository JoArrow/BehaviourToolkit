@tool
extends Control


const CONFIG_URL = "https://raw.githubusercontent.com/ThePat02/BehaviourToolkit/main/addons/behaviour_toolkit/plugin.cfg"


var current_selection: Node
var undo_redo: EditorUndoRedoManager


@onready var dialog_blackboard: FileDialog = $FileDialogNewBlackboard


func _ready():
	%Version.text = "BehaviourToolkit v" + str(%UpdateManager.current_version)

	# Connect buttons
	%ButtonState.connect("pressed", _on_button_pressed.bind(FSMState, "FSMState"))
	%ButtonTransition.connect("pressed", _on_button_pressed.bind(FSMTransition, "FSMTransition"))
	%ButtonStateIntegratedBT.connect("pressed", _on_button_pressed.bind(FSMStateIntegratedBT, "FSMStateIntegratedBT"))
	%ButtonStateIntegrationReturn.connect("pressed", _on_button_pressed.bind(FSMStateIntegrationReturn, "FSMStateIntegrationReturn"))

	%ButtonLeaf.connect("pressed", _on_button_pressed.bind(BTLeaf, "BTLeaf"))
	%ButtonPrint.connect("pressed", _on_button_pressed.bind(LeafPrint, "LeafPrint"))
	%ButtonWait.connect("pressed", _on_button_pressed.bind(LeafWait, "LeafWait"))
	%ButtonFSMEvent.connect("pressed", _on_button_pressed.bind(LeafFSMEvent, "LeafFSMEvent"))

	%ButtonComposite.connect("pressed", _on_button_pressed.bind(BTComposite, "BTComposite"))
	%ButtonSequence.connect("pressed", _on_button_pressed.bind(BTSequence, "BTSequence"))
	%ButtonSelector.connect("pressed", _on_button_pressed.bind(BTSelector, "BTSelector"))
	%ButtonRandom.connect("pressed", _on_button_pressed.bind(BTRandom, "BTRandom"))
	%ButtonRandomSequence.connect("pressed", _on_button_pressed.bind(BTRandomSequence, "BTRandomSequence"))
	%ButtonRandomSelector.connect("pressed", _on_button_pressed.bind(BTRandomSelector, "BTRandomSelector"))
	%ButtonIntegratedFSM.connect("pressed", _on_button_pressed.bind(BTIntegratedFSM, "BTIntegratedFSM"))

	%ButtonDecorator.connect("pressed", _on_button_pressed.bind(BTDecorator, "BTDecorator"))
	%ButtonAlwaysFail.connect("pressed", _on_button_pressed.bind(BTAlwaysFail, "BTAlwaysFail"))
	%ButtonAlwaysSucceed.connect("pressed", _on_button_pressed.bind(BTAlwaysSucceed, "BTAlwaysSucceed"))
	%ButtonLimiter.connect("pressed", _on_button_pressed.bind(BTLimiter, "BTLimiter"))
	%ButtonInverter.connect("pressed", _on_button_pressed.bind(BTInverter, "BTInverter"))
	%ButtonRepeat.connect("pressed", _on_button_pressed.bind(BTRepeat, "BTRepeat"))


func set_current_selection(new_selection):
	current_selection = new_selection


func _on_button_pressed(type, name: String):
	var new_node: BehaviourToolkit = type.new()

	# Check if name already exists
	var already_exists = false
	var count = 0
	for child in current_selection.get_children():
		if child.name.begins_with(name):
			count += 1
			already_exists = true

	if not already_exists:
		new_node.name = name
	else:
		new_node.name = name + str(count + 1)

	# Add undo/redo functionality
	undo_redo.create_action("Add new node")
	undo_redo.add_do_method(current_selection, "add_child", new_node)
	undo_redo.add_do_method(new_node, "set_owner", current_selection.get_tree().edited_scene_root)
	undo_redo.add_undo_method(current_selection, "remove_child", new_node)
	undo_redo.add_undo_method(new_node, "queue_free")
	undo_redo.commit_action()


func _on_button_blackboard_pressed():
	dialog_blackboard.popup_centered()


func _on_file_dialog_new_blackboard_file_selected(path:String):
	var new_blackboard := Blackboard.new()
	ResourceSaver.save(new_blackboard, path)
		

func _on_update_manager_update_available():
	%LinkGithub.show()
