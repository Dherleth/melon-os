class_name OSFileDefinition
extends Resource

enum FileType {
	TEXT,
	IMAGE,
	SOUND,
	FOLDER,
}

const FILE_TYPE_NAMES := {
	FileType.TEXT: "Text File",
	FileType.IMAGE: "Image File",
	FileType.SOUND: "Sound File",
	FileType.FOLDER: "Folder",
}

@export var path := ""
@export var modified := "01.01.01"
@export var type :FileType = FileType.TEXT
@export var size := "1 Ko"
@export var folder_content: Array[OSFileDefinition]
