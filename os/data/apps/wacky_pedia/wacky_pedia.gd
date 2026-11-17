extends OsAppScene

@onready var page_text: RichTextLabel = %PageText
@onready var home_page: Control = $HomePage
@onready var result_page: Control = $ResultPage
@onready var search_bar: LineEdit = %SearchBar
@onready var found_pages_container: GridContainer = %FoundPagesContainer

var wacky_page_button_scene = preload("res://os/data/apps/wacky_pedia/wacky_page_button.tscn")
var page_matching := {} #populated from the config json file
var found_pages := {} # Stores pages keys associated to the page title

func get_window_name() -> String:
	return app_definition.name


func setup() -> void:
	home_page.show()
	result_page.hide()
	search_bar.grab_focus()
	page_matching = _get_page_matching()


func _go_to_wacky_page(page_key: String) -> void:
	var text := _get_page_text(page_key)
	
	# Stores the new found page, we also store the title so we don't show keys 
	# to the user but a more readable text
	if not found_pages.has(page_key):
		var title_start = text.find("[wacky_title]") + "[wacky_title]".length()
		var title_end = text.find("[/wacky_title]")
		var title = text.substr(title_start, title_end - title_start)
		found_pages[page_key] = title
		var wacky_page_button := wacky_page_button_scene.instantiate() as WackyPageButton
		wacky_page_button.text = title
		wacky_page_button.page_key = page_key
		found_pages_container.add_child(wacky_page_button)
		wacky_page_button.pressed.connect(_go_to_wacky_page.bind(page_key))
		
	text = text.replace("[wacky_title]", "[table=2][cell shrink=false expand=100][font_size=50]")
	text = text.replace("[/wacky_title]", "[/font_size][/cell][cell]")
	text = text.replace("[wacky_image]", "[img height=200 align=top,top]res://os/data/apps/wacky_pedia/pages/%s.png[/img][/cell][/table]" % page_key)
	text = text.replace("[wacky_link=", "[wave][rainbow][url=")
	text = text.replace("[/wacky_link]", "[/url][/rainbow][/wave]")
	
	page_text.text = text
	home_page.hide()
	result_page.show()
			
			
func _on_search_bar_text_submitted(query: String) -> void:
	var page_key = _get_page_key(query)
	
	if page_key != "":
		search_bar.text = ""
		_go_to_wacky_page(page_key)
			
	
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
	_go_to_wacky_page(meta)


func _on_home_button_pressed() -> void:
	home_page.show()
	result_page.hide()
	search_bar.grab_focus()
