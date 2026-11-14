extends OsAppScene

var page_matching := {}

func get_window_name() -> String:
	return app_definition.name


func setup() -> void:
	page_matching = _get_page_matching()
	
	
func _on_search_bar_text_submitted(new_text: String) -> void:
	var page_key := _find_page_key(new_text)
	os_system.add_notification(page_key)
	

func _find_page_key(query: String) -> String:
	for key in page_matching:
		var possible_matches : Array = page_matching[key]
		if possible_matches.has(query):
			return key
	
	return ""


func _get_page_matching() -> Dictionary:
	var file_path := "res://os/data/apps/wacky_pedia/pages/page_matching.json"
	
	if not FileAccess.file_exists(file_path):
		push_error("File not found: ", file_path)
		return {}
	
	var file := FileAccess.open(file_path, FileAccess.READ)
	var content := file.get_as_text()
	file.close()
	
	var json := JSON.new()
	var error := json.parse(content)
	
	if error != OK:
		push_error("JSON parsing error: ", json.get_error_message())
		return {}
	
	return json.data
