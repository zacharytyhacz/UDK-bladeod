class BladePotion extends BladeItem
        ClassGroup(BladeItems,Potions)
        placeable;


// is the potion just a pickup and drink or one you put away?
var bool bQuickPotion;

// the amount of health it adds to the player
var int HealAmount;

function HealMe(Pawn Holder)
{
    if (BladeEntity(Holder) != None)
    {
        if(BladeEntity(Holder).bIsPoisoned == true)
        {
            BladeEntity(Holder).StopPoison(); // cure my plague
        }
        BladeEntity(Holder).Health += HealAmount;
        if(BladeEntity(Holder).Health > BladeEntity(Holder).HealthMax)
        {
            BladeEntity(Holder).Health = BladeEntity(Holder).HealthMax;
        }
    }
}

defaultproperties
{
    bQuickPotion=false
    HealAmount=100
    Hand=Hand
    ItemName="BladePotion"
    
    Begin Object Name=ItemMeshComponent
        SkeletalMesh=SkeletalMesh'BladeInventory.Items.Item_potion500'
        PhysicsAsset=PhysicsAsset'BladeInventory.Items.Item_potion500_Physics'
    End Object 
    
    Begin Object Name=CollisionCylinder
        CollisionRadius=10.0
        CollisionHeight=10.0
        BlockActors=true
        CollideActors=true
    End Object
}