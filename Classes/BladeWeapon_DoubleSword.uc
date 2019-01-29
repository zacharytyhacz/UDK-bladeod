class BladeWeapon_DoubleSword extends BladeWeapon
    placeable;
    
defaultproperties
{
    WeaponName="DoubleSword"
    MinLevel=1
    PowerDamage=10
    DefenseDamage=-15
    SwingEnergy=10
    bHidden=false
    Begin Object Name=WeaponMesh
        SkeletalMesh=SkeletalMesh'BladeInventory.Swords.sword_doublesword'
        PhysicsAsset=PhysicsAsset'BladeInventory.Swords.sword_doublesword_Physics'
        HiddenGame=false
    End Object
    
}