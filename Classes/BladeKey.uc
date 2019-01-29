class BladeKey extends BladeItem
    ClassGroup(BladeKeys,Keys)
    placeable;
   
defaultproperties
{   
    Begin Object Name=ItemMeshComponent
        SkeletalMesh=SkeletalMesh'BladeInventory.Items.Item_Key'
    End Object
	
	Begin Object Name=CollisionCylinder
        CollisionRadius=10.0
        CollisionHeight=10.0
        BlockActors=true
        CollideActors=true
    End Object
}