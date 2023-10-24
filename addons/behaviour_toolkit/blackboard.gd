class_name Blackboard extends Resource
## A blackboard is a dictionary of key/value pairs that can be used to share data between nodes.


## The blackboard's content stored as a dictionary.
var content: Dictionary


## Sets a value in the blackboard.
func set(key: StringName, value: Variant):
    content[key] = value


## Returns a value from the blackboard.
func get(key: StringName) -> Variant:
    return content[key]