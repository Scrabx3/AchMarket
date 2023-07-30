Scriptname BMPlayerScr extends ReferenceAlias

BMCaptures Property Captures Auto

Event OnInit()
	OnPlayerLoadGame()
EndEvent

Event OnPlayerLoadGame()
	Captures.Maintenance()
EndEvent
