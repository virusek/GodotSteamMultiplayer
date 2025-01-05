extends Node

@export var AppID = "480"
var lobby_id = 0
var peer = SteamMultiplayerPeer.new()

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
	print("Steam is running")

func _process(delta: float) -> void:
	Steam.run_callbacks()

func getUsername() -> String:
	var id = Steam.getSteamID()
	var username = Steam.getFriendPersonaName(id)
	return str(username)
	
func hostLobby():
	Steam.createLobby(Steam.LobbyType.LOBBY_TYPE_PUBLIC)
	peer.create_host(0)
	multiplayer.multiplayer_peer = peer

func on_host_lobby_created(connect, id):
	if connect:
		lobby_id = id
		Steam.setLobbyData(id, "name", getUsername()+"'s Lobby")
		Steam.setLobbyJoinable(id, true)
		print("Successfully created a steam lobby")

func on_lobby_joined(lobby, perms, locked, response):
	print(lobby)
	var id := Steam.getLobbyOwner(lobby)
	if id == Steam.getSteamID():
		return
	peer.create_client(id, 0)
	multiplayer.multiplayer_peer = peer
	
	#TODO: Fix scene changes
	SceneManager.start_game()
	pass
