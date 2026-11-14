extends OsAppScene

var page_matching := {}

func get_window_name() -> String:
	return app_definition.name


func setup() -> void:
	page_matching = _get_page_matching()
	
	
func _on_search_bar_text_submitted(new_text: String) -> void:
	var page_key := _get_page_key(new_text)
	
	if page_key != "":
		var page_text := _get_page_text(page_key)
		var page_image := _get_page_image(page_key)
	
	
func _get_page_text(page_key: String) -> String:
	var file_path := "res://os/data/apps/wacky_pedia/pages/" + page_key + ".txt"
	
	if not FileAccess.file_exists(file_path):
		push_error("File not found: ", file_path)
		return ""
	
	var file := FileAccess.open(file_path, FileAccess.READ)
	var content := file.get_as_text()
	file.close()
	
	return content
	
func _get_page_image(page_key: String) -> Texture2D:
	var file_path := "res://os/data/apps/wacky_pedia/pages/" + page_key + ".png"
	
	if not FileAccess.file_exists(file_path):
		push_error("File not found: ", file_path)
		return null

	var texture: Texture2D = load(file_path)
	
	return texture
	
func _get_page_key(query: String) -> String:
	for key in page_matching:
		var possible_matches : Array = page_matching[key]
		if possible_matches.has(query):
			return key
	
	return ""


func _get_page_matching() -> Dictionary:
	var file_path := "res://os/data/apps/wacky_pedia/page_matching.json"
	
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
