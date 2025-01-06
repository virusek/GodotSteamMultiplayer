extends Control

func _ready() -> void:
	%UsernameLabel.text = "Username: " + SteamManager.getUsername()
	SteamManager.LobbiesFetched.connect(createLobbyList)

func _on_host_button_pressed() -> void:
	SteamManager.hostLobby()
	SceneManager.start_game()
	pass

func _on_join_button_pressed() -> void:
	SteamManager.fetchLobbies()
	%ButtonContainer.hide()
	%LobbyContainer.show()

#FIXME: Joining lobbies not implemented
func createLobbyList():
	for i in SteamManager.fetchedLobbies:
		var lobbyItem = Button.new()
		lobbyItem.text = i
		%LobbyListContainer.add_child(lobbyItem)

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_back_button_pressed() -> void:
	%ButtonContainer.show()
	%LobbyContainer.hide()
