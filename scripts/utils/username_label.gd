extends Label

func _ready() -> void:
	var username = SteamManager.getUsername()
	text = username
