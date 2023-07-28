;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname QF_AchMarket_Bounty01_069764A2 Extends Quest Hidden

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY MapMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_MapMarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Boss
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Boss Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY BountyLoc
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_BountyLoc Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Charon
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Charon Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
; Player accepted quest
SetObjectiveDisplayed(10)

ObjectReference marker = Alias_MapMarker.GetRef()
If (marker)
marker.AddToMap()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
; Player captured Target actor
SetObjectiveCompleted(10)
SetObjectiveDisplayed(50)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
; Bandit died
FailAllObjectives()
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN AUTOCAST TYPE BMBounty
Quest __temp = self as Quest
BMBounty kmyQuest = __temp as BMBounty
;END AUTOCAST
;BEGIN CODE
; Player completed the quest by handing over the target to Charon
CompleteAllObjectives()
Alias_Player.GetRef().AddItem(FavorRewardGoldLarge)

kmyQuest.Stage100()

Stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

LeveledItem Property FavorRewardGoldLarge  Auto  
