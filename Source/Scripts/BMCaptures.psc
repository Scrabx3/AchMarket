ScriptName BMCaptures extends Quest

BMCapturesAlias[] Property CaptureRefs Auto
ObjectReference Property HoldingCellMarker Auto
Actor Property PlayerRef Auto

Message Property MsgNoStorageSpace Auto
Keyword Property MarketTargetKW Auto

ImageSpaceModifier Property FadeToBlackAndBackFastImod Auto
ImageSpaceModifier Property FadeToBlackFastImod Auto
ImageSpaceModifier Property FadeToBlackHoldImod Auto
ImageSpaceModifier Property FadeToBlackBackFastImod Auto

GlobalVariable Property GameDay Auto
GlobalVariable Property GameMonth Auto
GlobalVariable Property GameYear Auto
GlobalVariable Property GameHour Auto

; ======================
; ======== INTERFACE
; ======================

String Property CaptureOptionID = "AchBM_CAPTURE" AutoReadOnly

; Called on every game load
Function Maintenance()
  Debug.Trace("[BlackMarket] Captures Maintenance")
  If (!Acheron.HasOption(CaptureOptionID))
    Acheron.AddOption(CaptureOptionID, "Capture", "BlackMarket\\Captures.swf{0}", "{\"Target\":{\"NOT\":{\"Keywords\":[\"0x952C07|AchBlackMarket.esp\",\"0x952C05|AchBlackMarket.esp\"]},\"IS\":[\"NonEssential\"]}}")
  EndIf
  Acheron.RegisterForHunterPrideSelect(self)
  RegisterForKey(35)
EndFunction

Event OnHunterPrideSelect(int aiOptionID, Actor akTarget)
  If (aiOptionID != Acheron.GetOptionID(CaptureOptionID))
    return
  EndIf
  CaptureActor(akTarget)
EndEvent

Event OnKeyDown(int keyCode)
  OpenCapturesMenu()
EndEvent

Function OpenCapturesMenu()
  UI.OpenCustomMenu("AchMarketCapturesMenu")
  int i = 0
  While (i < CaptureRefs.Length)
    If (CaptureRefs[i].GetReference())
      UI.InvokeStringA("CustomMenu", "_root.main.AddOption", CaptureRefs[i].GetMenuData())
    EndIf
    i += 1
  EndWhile
  UI.Invoke("CustomMenu", "_root.main.OpenMenu")
EndFunction

; ======================
; ======== STORE & LOAD
; ======================

; Sort an Actor into the List of Defeated Victims
bool Function CaptureActor(Actor akTarget)
  BMCapturesAlias refalias = GetEmptyRef()
  If (!refalias)
    Debug.Trace("[BlackMarket] No available empty alias to capture actor in")
    MsgNoStorageSpace.Show()
    return false
  EndIf
  ActorBase base = akTarget.GetLeveledActorBase()
  ActorBase template = base.GetTemplate()
  FadeToBlackAndBackFastImod.Apply()
  Utility.Wait(0.5)
  If(!template || akTarget.HasKeyword(MarketTargetKW) || base.IsEssential() || base.IsProtected())
    refalias.ForceRefTo(akTarget)
    Acheron.RescueActor(akTarget, true)
  Else
    akTarget.KillSilent(PlayerRef)
    ObjectReference ref = akTarget.PlaceAtMe(template)
    refalias.ForceRefTo(ref)
    ref.MoveTo(HoldingCellMarker)
  EndIf
  akTarget.MoveTo(HoldingCellMarker)
  akTarget.SendModEvent("AchBM_ActorCaptured")
  return true
EndFunction

bool Function LoadCapture(Actor akTarget)
  BMCapturesAlias ref = GetRef(akTarget)
  If (!ref)
    Debug.TraceStack("[BlackMarket] Actor " + akTarget + " is not captured.")
    return false
  EndIf
  Acheron.DefeatActor(akTarget)
  FadeToBlackFastImod.Apply()
  Utility.Wait(0.5)
  FadeToBlackFastImod.PopTo(FadeToBlackHoldImod)
  float Z = PlayerRef.GetAngleZ()
  akTarget.MoveTo(PlayerRef, 120.0 * Math.Sin(Z), 120.0 * Math.Cos(Z), PlayerRef.GetHeight() - 35.0)
  Debug.SendAnimationEvent(akTarget, "BleedoutStart")
  Utility.Wait(0.4)
  FadeToBlackHoldImod.PopTo(FadeToBlackBackFastImod)
EndFunction

bool Function RemoveCapture(Actor akTarget)
  BMCapturesAlias ref = GetRef(akTarget)
  If (!ref)
    Debug.TraceStack("[BlackMarket] Actor " + akTarget + " is not captured.")
    return false
  EndIf
  ref.Clear()
  ; Shift the ref to be cleared to the end of array to make re-using references
  ; more consistent in the menu (always listing older captures before new ones)
  int i = CaptureRefs.Find(ref)
  While(i < CaptureRefs.Length - 1)
    If (!CaptureRefs[i + 1].GetReference())
      return true
    EndIf
    CaptureRefs[i + 1] = CaptureRefs[i]
    i += 1
  EndWhile
  return true
EndFunction

; ======================
; ======== UTILITY
; ======================

BMCapturesAlias Function GetEmptyRef()
  int i = 0
  While(i < CaptureRefs.Length)
    If(!CaptureRefs[i].GetReference())
      return CaptureRefs[i]
    EndIf
    i += 1
  EndWhile
  return none
EndFunction

BMCapturesAlias Function GetRef(Actor akReference)
  int i = 0
  While(i < CaptureRefs.Length)
    If(CaptureRefs[i].GetReference() == akReference)
      return CaptureRefs[i]
    EndIf
    i += 1
  EndWhile
  return none
EndFunction

String Function CreateGameTimeString()
  String ret
  int day = GameDay.GetValueInt()
  If(day == 1)
    ret = "1st of "
  ElseIf(day == 2)
    ret = "2nd of "
  ElseIf(day == 3)
    ret = "3rd of "
  Else
    ret = day + "th of "
  EndIf
  int month = GameMonth.GetValueInt() + 1
  If(month == 1)
    ret += "of Morning Star "
  ElseIf(month == 2)
    ret += "of Sun's Dawn "
  ElseIf(month == 3)
    ret += "of First Seed "
  ElseIf(month == 4)
    ret += "of Rain's Hand "
  ElseIf(month == 5)
    ret += "of Second Seed "
  ElseIf(month == 6)
    ret += "of Mid Year "
  ElseIf(month == 7)
    ret += "of Sun's Height "
  ElseIf(month == 8)
    ret += "of Last Seed "
  ElseIf(month == 9)
    ret += "of Hearthfire "
  ElseIf(month == 10)
    ret += "of Frost Fall "
  ElseIf(month == 11)
    ret += "of Sun's Dusk "
  ElseIf(month == 12)
    ret += "of Evening Star "
  EndIf
  ret += "4E " + GameYear.GetValueInt() + " / "
  int hour = GameHour.GetValueInt()
  ret += hour + ":"
  float minute = (GameHour.Value - hour)
  ret += (minute * 60) as int
  Debug.Trace("[BlackMarket] Returning Date = " + ret)
  return ret
EndFunction
