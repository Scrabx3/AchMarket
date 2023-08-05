Scriptname BMAnimalController extends Quest  

ReferenceAlias Property TamedAlias Auto
ObjectReference Property TamedSpawn Auto
ActorBase[] Property TamedBases Auto
GlobalVariable[] Property Costs Auto

MiscObject Property Gold001 Auto

int Property COST_WOLF = 0 AutoReadOnly
int Property COST_SABRECAT = 1 AutoReadOnly
int Property COST_BEAR = 2 AutoReadOnly
int Property COST_TROLL = 3 AutoReadOnly
int Property COST_DEATHHOUND = 4 AutoReadOnly


Function MakeBeastFollower(int aiCostID, bool abChargePlayer = true)
  If (abChargePlayer)
    Game.GetPlayer().RemoveItem(Gold001, Costs[aiCostID].GetValueInt())
  EndIf
  Actor newtamed = TamedSpawn.PlaceAtMe(TamedBases[aiCostID]) as Actor
  TamedAlias.ForceRefTo(newtamed)
  newtamed.SetPlayerTeammate(abCanDoFavor = false)
EndFunction

Function Wait()
  TamedAlias.GetActorReference().SetAv("WaitingForPlayer", 1)
EndFunction

Function Follow()
  TamedAlias.GetActorReference().SetAv("WaitingForPlayer", 0)
EndFunction

Function DismissBeastFollower(bool abSell = false)
  Actor tamed = TamedAlias.GetActorReference()
  If (abSell)
    ActorBase base = tamed.GetActorBase()
    int where = TamedBases.Find(base)
    If(where == -1)
      Debug.Trace("[BlackMarket] Base " + base + " not found in Tamed Bases " + TamedBases)
      where = 0
    EndIf
    int add = Math.Floor(Costs[where].GetValue() / 2)
    Game.GetPlayer().AddItem(Gold001)
    tamed.Disable()
    tamed.Delete()
  Else
    tamed.SetAV("Aggression", 2)
  EndIf
	tamed.SetPlayerTeammate(false)
	tamed.StopCombatAlarm()

  TamedAlias.Clear()
EndFunction
