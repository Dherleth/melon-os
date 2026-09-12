class_name OSDirectory
extends OSFileSystemEntry

var children: Array[OSFileSystemEntry] = []


func get_child_by_name(child_name: String) -> OSFileSystemEntry:
	for child in children:
		if child.name == child_name:
			return child

	return null


func add_child_entry(entry: OSFileSystemEntry) -> void:
	children.append(entry)


func remove_child_entry(entry: OSFileSystemEntry) -> void:
	children.erase(entry)
