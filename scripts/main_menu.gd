extends Control

func _ready() -> void:
	%UsernameLabel.text = "Username: " + SteamManager.getUsername()

func _on_host_button_pressed() -> void:
	SteamManager.hostLobby()
	SceneManager.start_game()
	pass

func _on_join_button_pressed() -> void:
	SceneManager.start_game()
	pass

func _on_quit_button_pressed() -> void:
	get_tree().quit()
