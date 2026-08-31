class_name OSFileSystem
extends Node

var root: OSDirectory


func initialize() -> void:
	root = OSDirectory.new()
	root.name = "/"
	

func create_directory(path: String) -> OSDirectory:
	if path == "/":
		return root

	var parent_path := path.get_base_dir()
	var directory_name := path.get_file()

	var parent := get_directory(parent_path)

	if parent == null:
		return null

	var existing := parent.get_child_by_name(directory_name)

	if existing:
		if existing is OSDirectory:
			return existing

		return null

	var directory := OSDirectory.new()
	directory.name = directory_name

	parent.add_child_entry(directory)

	return directory
	
	
func get_directory(path: String) -> OSDirectory:
	if path == "/" or path.is_empty():
		return root

	var parts := path.split("/", false)

	var current := root

	for part in parts:
		var child := current.get_child_by_name(part)

		if child == null:
			return null

		if not child is OSDirectory:
			return null

		current = child

	return current
	

func create_file(path: String,content: String = "") -> OSFile:

	var directory_path := path.get_base_dir()
	var file_name := path.get_file()

	var directory := get_directory(directory_path)

	if directory == null:
		return null

	var existing := directory.get_child_by_name(file_name)

	if existing:
		if existing is OSFile:
			return existing

		return null

	var file := OSFile.new()
	file.name = file_name
	file.content = content

	directory.add_child_entry(file)

	return file

func get_file(path: String) -> OSFile:
	var directory_path := path.get_base_dir()
	var file_name := path.get_file()

	var directory := get_directory(directory_path)

	if directory == null:
		return null

	var entry := directory.get_child_by_name(file_name)

	if entry is OSFile:
		return entry

	return null


func read_file(path: String) -> String:
	var file := get_file(path)

	if file == null:
		push_error("File not found: " + path)
		return ""

	return file.content
	

func write_file(path: String,content: String) -> bool:
	var file := get_file(path)

	if file == null:
		return false

	file.content = content

	return true

func list_directory(path: String) -> Array[OSFileSystemEntry]:

	var directory := get_directory(path)

	if directory == null:
		return []

	return directory.children.duplicate()
	
	
func exists(path: String) -> bool:
	if path == "/":
		return true

	return (
		get_file(path) != null
		or
		get_directory(path) != null
	)
	
	
func delete_file(path: String) -> bool:
	var file := get_file(path)

	if file == null:
		return false

	var directory := get_directory(
		path.get_base_dir()
	)

	if directory == null:
		return false

	directory.remove_child_entry(file)

	return true


func delete_directory(path: String) -> bool:
	if path == "/":
		return false

	var directory := get_directory(path)

	if directory == null:
		return false

	var parent := get_directory(
		path.get_base_dir()
	)

	if parent == null:
		return false

	parent.remove_child_entry(directory)

	return true


func move(source_path: String, destination_path: String) -> bool:
	var source_parent := get_directory(
		source_path.get_base_dir()
	)

	var destination_parent := get_directory(
		destination_path.get_base_dir()
	)

	if source_parent == null:
		return false

	if destination_parent == null:
		return false

	var entry := source_parent.get_child_by_name(
		source_path.get_file()
	)

	if entry == null:
		return false

	if destination_parent.get_child_by_name(destination_path.get_file()):
		return false

	source_parent.remove_child_entry(entry)

	entry.name = destination_path.get_file()

	destination_parent.add_child_entry(entry)

	return true


func rename(path: String,new_name: String) -> bool:
	return move(
		path,
		path.get_base_dir().path_join(new_name)
	)


func load_definition(
	definition: OSFileSystemDefinition
) -> void:

	root = build_directory(
		definition.root
	)
	
func build_directory(
	definition: OSDirectoryDefinition
) -> OSDirectory:

	var directory := OSDirectory.new()
	directory.name = definition.name

	for file_definition in definition.files:
		var file := OSFile.new()

		file.name = file_definition.name
		file.content = file_definition.content

		directory.add_child_entry(file)

	for directory_definition in definition.directories:
		var child_directory := build_directory(
			directory_definition
		)

		directory.add_child_entry(child_directory)

	return directory
