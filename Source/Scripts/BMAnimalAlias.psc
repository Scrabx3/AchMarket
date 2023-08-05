Scriptname BMAnimalAlias extends ReferenceAlias  

BMAnimalController Property Controller
  BMAnimalController Function Get()
    return GetOwningQuest() as BMAnimalController
  EndFunction
EndProperty

Event OnUnload()
  If (GetActorReference().GetAV("WaitingForPlayer") == 1)
    RegisterForSingleUpdateGameTime(48)
  EndIf
EndEvent

Event OnLoad()
  If (GetActorReference().GetAV("WaitingForPlayer") == 0)
    UnregisterForUpdate()
  EndIf
EndEvent

Event OnUpdateGameTime()
  Controller.DismissBeastFollower()
EndEvent

Event OnDeath(Actor akKiller)
  Controller.DismissBeastFollower()
EndEvent

Event OnCellAttach()
  GetActorReference().AllowPCDialogue(true)
EndEvent

Function Clear()
  GetActorReference().AllowPCDialogue(false)
  Parent.Clear()
EndFunction
