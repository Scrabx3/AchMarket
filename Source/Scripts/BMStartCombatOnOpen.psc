Scriptname BMStartCombatOnOpen extends ObjectReference  

Event OnOpen(ObjectReference akActionRef)
  Actor actionref = akActionRef as Actor
  If (!actionref)
    return
  EndIf
  Actor link = GetLinkedRef() as Actor
  While (link)
    link.StartCombat(actionref)
    link = link.GetLinkedRef() as Actor
  EndWhile  
EndEvent
