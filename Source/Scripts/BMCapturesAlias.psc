Scriptname BMCapturesAlias extends ReferenceAlias  
{Script to maintain captured actors}

BMCaptures Property Captures
  BMCaptures Function Get()
    return GetOwningQuest() as BMCaptures
  EndFunction
EndProperty

Location _ogLocation
String[] _data

String[] Function GetMenuData()
  String[] data = Utility.ResizeStringArray(_data, _data.Length + 1, "0")
  If (GetReference().HasKeyword(Captures.MarketTargetKW))
    data[5] = "1"
  EndIf
  return data
EndFunction

Function ForceRefTo(ObjectReference akNewRef)
  Actor actorref = akNewRef as Actor
  If (!actorref)
    Debug.TraceStack("Cannot force a non actor to a captures alias")
    return
  EndIf
  ActorBase base = actorref.GetLeveledActorBase()
  _ogLocation = akNewRef.GetCurrentLocation()
  _data = new String[6]
  _data[0] = GetID()
  _data[1] = base.GetName()
  _data[2] = actorref.GetLevel()
  _data[3] = base.GetSex()
  If (_ogLocation)
    _data[4] = _ogLocation.GetName()
  Else
    _data[4] = "Wilderness"
  EndIf
  _data[5] = Captures.CreateGameTimeString()

  Parent.ForceRefTo(akNewRef)
EndFunction
