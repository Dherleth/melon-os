extends OsAppScene

@onready var page_text: RichTextLabel = %PageText
@onready var home_page: Control = $HomePage
@onready var result_page: Control = $ResultPage

var page_matching := {}


func get_window_name() -> String:
	return app_definition.name


func setup() -> void:
	home_page.show()
	result_page.hide()
	page_matching = _get_page_matching()
	
	
func _on_search_bar_text_submitted(new_text: String) -> void:
	var page_key := _get_page_key(new_text)
	
	if page_key != "":
		var text := _get_page_text(page_key)
		
		if text != "":
			text = text.replace("[wacky_title]", "[table=2][cell shrink=false expand=100][font_size=50]")
			text = text.replace("[wacky_image]", "[/font_size][/cell][cell][img height=200 align=top,top]res://os/data/apps/wacky_pedia/pages/%s.png[/img][/cell][/table]" % page_key)
			text = text.replace("[wacky_link=", "[wave][rainbow][url=")
			text = text.replace("[/wacky_link]", "[/url][/rainbow][/wave]")
			page_text.text = text
			home_page.hide()
			result_page.show()
			
	
func _get_page_text(page_key: String) -> String:
	var file_path := "res://os/data/apps/wacky_pedia/pages/" + page_key + ".txt"
	
	if not FileAccess.file_exists(file_path):
		push_error("File not found: ", file_path)
		return ""
	
	var file := FileAccess.open(file_path, FileAccess.READ)
	var content := file.get_as_text()
	file.close()
	
	return content

	
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


func _on_page_text_meta_clicked(meta: Variant) -> void:
	_on_search_bar_text_submitted(meta)
