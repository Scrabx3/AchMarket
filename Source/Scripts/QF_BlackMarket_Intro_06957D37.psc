;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 7
Scriptname QF_BlackMarket_Intro_06957D37 Extends Quest Hidden

;BEGIN ALIAS PROPERTY Scrooge
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Scrooge Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Charlotte
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Charlotte Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Alchemist
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Alchemist Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Charon
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Charon Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
; Charon first talks to the player
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
; Stage5: Looking for invitation
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
; Stage50, handed over invitation and can enter Lobby
LobbyDoor.Lock(false, true)

SetObjectiveDisplayed(50)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
CompleteAllObjectives()

CellarDoor.Lock(false, true)
LabDoor.Lock(false, true)
SleepDoor.Lock(false, true)

Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
; Player disagreed to join, 
; this wont change anything on the story but may still be relevant to some dialogue
SetStage(200)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
; Player walks up to scrooge for the first time (disable forcegreet package)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ObjectReference Property LobbyDoor Auto

ObjectReference Property LabDoor  Auto  

ObjectReference Property SleepDoor  Auto  

ObjectReference Property CellarDoor  Auto  
