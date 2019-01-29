class BladeArmor extends BladeItem;

var(Armor) int ArmorLevel;


simulated function ChangeArmor(Pawn P)
{
    if(P != None)
    {
        if(BladePawn(P) != None)
        {
            BladePawn(P).SetArmorLevel(ArmorLevel);
        }
    }
 } 

defaultproperties
{
}
