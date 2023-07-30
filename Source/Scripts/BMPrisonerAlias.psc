Scriptname BMPrisonerAlias extends ReferenceAlias  

ObjectReference Property PrisonCellDoor Auto
{ Door of the prison cell to lock the actor in. Should have a linked ref to some marker to move the prisoner to }
float Property ImprisonTime = 72.0 Auto
{ Time the Cell should be occupied before its cleared, in game hours }
Key Property CellKey Auto
{ The key to lock the door with }

BMCaptures Property Captures
  BMCaptures Function Get()
    return GetOwningQuest() as BMCaptures
  EndFunction
EndProperty

Function ForceRefTo(ObjectReference akNewRef)
  If (!akNewRef as Actor)
    Debug.TraceStack("[BlackMarket] Cannot force a non actor to a prisoner ref")
    return
  EndIf
  akNewRef.MoveTo(PrisonCellDoor.GetLinkedRef())
  PrisonCellDoor.SetOpen(false)
  PrisonCellDoor.SetLockLevel(75)
  PrisonCellDoor.Lock(true)
  If (ImprisonTime)
    RegisterForSingleUpdateGameTime(ImprisonTime)
  EndIf
  Parent.ForceRefTo(akNewRef)
EndFunction

Event OnUpdateGameTime()
  Clear()
EndEvent

Function Clear()
  GetReference().MoveTo(Captures.HoldingCellMarker)
  If (Utility.RandomInt(0, 1))
    PrisonCellDoor.SetOpen(true)
  EndIf
  PrisonCellDoor.Lock(false)
  Parent.Clear()
EndFunction
