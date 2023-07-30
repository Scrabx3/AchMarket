Scriptname BMBounty extends Quest

BMCaptures Property Captures Auto
ReferenceAlias Property Target Auto

Location Property TheMarket Auto

Function PlayerChangeLocation()
  If (GetStage() < 10 && !Game.GetPlayer().IsInLocation(TheMarket))
    ; Player left market without accepting quest
    Stop()
  EndIf
EndFunction

Function PlayerReloadGame()
  RegisterForModEvent("AchBM_ActorCaptured", "OnActorCaptured")
EndFunction

; Accept quest and  wait for actor capture
Function Stage10()
  PlayerReloadGame()
EndFunction

Event OnActorCaptured(string asEventName, string asStringArg, float afNumArg, form akSender)
  If (akSender == Target.GetReference())
    SetStage(50)
  EndIf
EndEvent

; Remove Actor from Captured Aliases
Function Stage100()
  Captures.Imprison(Target.GetReference() as Actor)
EndFunction
