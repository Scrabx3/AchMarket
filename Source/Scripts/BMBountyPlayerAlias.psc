Scriptname BMBountyPlayerAlias extends ReferenceAlias  

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
  (GetOwningQuest() as BMBounty).PlayerChangeLocation()
EndEvent

Event OnPlayerLoadGame()
  (GetOwningQuest() as BMBounty).PlayerReloadGame()
EndEvent
