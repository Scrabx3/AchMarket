ScriptName BMCaptures extends Quest Conditional

BMCapturesAlias[] Property CaptureRefs Auto
BMPrisonerAlias[] Property PrisonerRefs Auto
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

Keyword Property SMReservecCheckRef Auto
MiscObject Property Gold001 Auto

; ======================
; ======== INTERFACE
; ======================

String Property CaptureOptionID = "AchBM_CAPTURE" AutoReadOnly

int Property CAPTURES_NONE = 0 AutoReadOnly
int Property CAPTURES_FREESELECT = 1 AutoReadOnly
int Property CAPTURES_SELLSELECT = 2 AutoReadOnly
int _CapturesMode

int _CapturesModifierKey

; Called on every game load
Function Maintenance()
  Debug.Trace("[BlackMarket] Captures Maintenance")
  If (!Acheron.HasOption(CaptureOptionID))
    Acheron.AddOption(CaptureOptionID, "Capture", "AchMarket_CaptureIcon.swf", "{\"Target\":{\"NOT\":{\"Keywords\":[\"0x952C07|AchMarket.esp\",\"0x952C05|AchMarket.esp\"]},\"IS\":[\"NonEssential\"]}}")
  EndIf
  Acheron.RegisterForHunterPrideSelect(self)
  RegisterForModEvent("AchMarket_SELECT", "OnCaptureSelect")
  RegisterForModEvent("AchMarket_CANCEL", "OnCaptureCancel")

  UnregisterForAllKeys()
  int jObj = JValue.readFromFile("Data\\SKSE\\AchMarket\\Settings.json")
  _CapturesModifierKey = JMap.getInt(jObj, "modifier", -1)
  int keycode = JMap.getInt(jObj, "keycode", 35)
  RegisterForKey(keycode)
EndFunction

Event OnHunterPrideSelect(int aiOptionID, Actor akTarget)
  If (aiOptionID != Acheron.GetOptionID(CaptureOptionID))
    return
  EndIf
  CaptureActor(akTarget)
EndEvent

Event OnKeyDown(int keyCode)
  If (Utility.IsInMenuMode() || !Game.IsLookingControlsEnabled())
		return
  ElseIf (_CapturesModifierKey > 0 && !Input.IsKeyPressed(_CapturesModifierKey))
    return
  EndIf
  _CapturesMode = CAPTURES_FREESELECT
  OpenCapturesMenu()
EndEvent

Function SellCaptureSelect()
  _CapturesMode = CAPTURES_SELLSELECT
  OpenCapturesMenu()
EndFunction

Function OpenCapturesMenu()
  UI.OpenCustomMenu("AchMarketCapturesMenu")
  int i = 0
  While (i < CaptureRefs.Length)
    If (CaptureRefs[i].GetReference())
      UI.InvokeStringA("CustomMenu", "_root.main.SetData", CaptureRefs[i].GetMenuData())
    EndIf
    i += 1
  EndWhile
EndFunction

Event OnCaptureSelect(string asEventName, string asAliasID, float afNumArg, form akSender)
  BMCapturesAlias select = GetAlias(asAliasID as int) as BMCapturesAlias
  If (!select)
    Debug.TraceStack("[BlackMarket] Invalid SelectionID")
  ElseIf (_CapturesMode == CAPTURES_FREESELECT)
    LoadCapture(select.GetActorReference())
  ElseIf (_CapturesMode == CAPTURES_SELLSELECT)
    SellCapture(select)
  EndIf
  _CapturesMode = CAPTURES_NONE
EndEvent

Event OnCaptureCancel(string asEventName, string asStringArg, float afNumArg, form akSender)
  _CapturesMode = CAPTURES_NONE
EndEvent

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
  RemoveCaptureImpl(ref)
EndFunction

bool Function RemoveCapture(Actor akTarget)
  BMCapturesAlias ref = GetRef(akTarget)
  If (!ref)
    Debug.TraceStack("[BlackMarket] Actor " + akTarget + " is not captured.")
    return false
  EndIf
  RemoveCaptureImpl(ref)
EndFunction

Function RemoveCaptureImpl(BMCapturesAlias akAlias)
  akAlias.Clear()
  ; Shift the ref to be cleared to the end of array to make re-using references
  ; more consistent in the menu (always listing older captures before new ones)
  int i = CaptureRefs.Find(akAlias)
  While(i < CaptureRefs.Length - 1 && CaptureRefs[i + 1].GetReference())
    CaptureRefs[i] = CaptureRefs[i + 1]
    i += 1
  EndWhile
  CaptureRefs[i] = akAlias
EndFunction

Function SellCapture(BMCapturesAlias akSellRef)
  Actor selling = akSellRef.GetActorReference()
  int price = 50 + selling.GetLevel() * 3
  If (selling.GetActorBase().IsUnique())
    price += 1000
  EndIf
  PlayerRef.AddItem(Gold001, price)
  Imprison(akSellRef.GetActorReference())
EndFunction

Function Imprison(Actor akPrisoner)
  If(!RemoveCapture(akPrisoner))
    return
  EndIf
  int i = 0
  While(i < PrisonerRefs.Length)
    If (PrisonerRefs[i].ForceRefIfEmpty(akPrisoner))
      return
    EndIf
    i += 1
  EndWhile
  Debug.Trace("[BlackMarket] Actor " + akPrisoner + " cannot be imprisoned. No cells are available")
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
  ; Debug.Trace("[BlackMarket] Returning Date = " + ret)
  return ret
EndFunction
