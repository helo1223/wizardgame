extends Node

#Steam variables
var OWNED = false
var ONLINE = false
var STEAM_ID = 0
var STEAM_NAME = ""
#Lobby variables
var DATA
var LOBBY_ID = 0
var LOBBY_MAX_MEMBERS = 10
var LOBBY_MEMBERS = []
var LOBBY_INVITE_ARG = false

var AppID = "480"

func _init():
    OS.set_environment("SteamAppID", AppID)
    OS.set_environment("SteamGameID", AppID)

func initialize_steam():
    var INIT = Steam.steamInitEx()
    if INIT['status'] > 0:
        print("Failed to initialize Steam. " + str(INIT['verbal']) + " Shutting down...")
        get_tree().quit()
        
    ONLINE = Steam.loggedOn()
    STEAM_ID = Steam.getSteamID()
    STEAM_NAME = Steam.getPersonaName()
    OWNED = Steam.isSubscribed()

func _process(_delta):
    Steam.run_callbacks()
