class BladeEnemySpawn extends NavigationPoint placeable ClassGroup(Common);

var(Enemy) bool                 bSpawnOnStart; // Should this enemy spawn when the map starts?
var(Enemy) class<BladeAIPawn>   PawnToSpawn;   // What pawn should should i spawn?
var(Enemy) class<BladeWeapon>   BWeapon;	   // What weapon will the pawn have?
var(Enemy) class<BladeShield>   Shield;        // What shield will the pawn have?
var(Enemy) int                  Level;         // What level will the pawn be?
var(Enemy) class<BladeItem>     DroppableItem; // Will the pawn drop an item when it dies? potion, key,etc
var(Enemy) int                  ExpToGive;	   // How much extra experience should this pawn give? 
var(Enemy) int                  Aggression;    // Extra variable to randomize pawns
var(Enemy) const array<BladeWalkNode>	WalkNode;  // Optional. Walknodes (BladeWalkNode) for when the pawn is idle
var 	    bool 				bInUse;		   // Is this spawn point being used to spawn a pawn?							

defaultproperties
{
    bSpawnOnStart=true    
    
    Components.Remove(Sprite)
    
    Begin Object Class=SkeletalMeshComponent Name=EditorComponent
        SkeletalMesh=SkeletalMesh'BladeSkins.skins.Skin_Boxes'
        HiddenGame=True
    End Object
    Components.add(EditorComponent)
}