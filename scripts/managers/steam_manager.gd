extends Node

signal LobbiesFetched

@export var AppID = "480"
var lobby_id = 0
var peer = SteamMultiplayerPeer.new()

var fetchedLobbies = []

func _init() -> void:
	OS.set_environment("SteamAppID", AppID)
	OS.set_environment("SteamGameID", AppID)

func _ready() -> void:
	Steam.steamInit()
	var isRunning = Steam.isSteamRunning()
	
	if !isRunning:
		print("ERROR: Steam is not running")
		return
	
	Steam.lobby_created.connect(on_host_lobby_created)
	Steam.lobby_joined.connect(on_lobby_joined)
	Steam.join_requested.connect(on_join_requested)
	Steam.lobby_match_list.connect(on_lobby_match_list)
	print("Steam is running")

func _process(_delta: float) -> void:
	Steam.run_callbacks()

func getUsername() -> String:
	var id = Steam.getSteamID()
	var username = Steam.getFriendPersonaName(id)
	return str(username)
	
func hostLobby():
	Steam.createLobby(Steam.LobbyType.LOBBY_TYPE_FRIENDS_ONLY)
	peer.create_host(0)
	multiplayer.multiplayer_peer = peer

func on_host_lobby_created(connection, id):
	if connection:
		lobby_id = id
		Steam.setLobbyData(id, "name", getUsername()+"'s Lobby")
		Steam.setLobbyJoinable(id, true)
		print("Successfully created a steam lobby")

func joinLobby(lobby):
	Steam.joinLobby(lobby)

func fetchLobbies():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.requestLobbyList()

func on_lobby_match_list(these_lobbies: Array) -> void:
	fetchedLobbies.clear()
	for this_lobby in these_lobbies:
		var lobby_name: String = Steam.getLobbyData(this_lobby, "name")
		if !lobby_name.is_empty():
			fetchedLobbies.push_back(lobby_name)
	LobbiesFetched.emit()

func on_lobby_joined(lobby, _perms, _locked, _response):
	print(lobby)
	lobby_id = lobby
	var id := Steam.getLobbyOwner(lobby)
	if id == Steam.getSteamID():
		return
	peer.create_client(id, 0)
	multiplayer.multiplayer_peer = peer

	SceneManager.start_game()
	pass

func on_join_requested(lobby, _acc):
	print("Join Requested!")
	joinLobby(lobby)
	pass
