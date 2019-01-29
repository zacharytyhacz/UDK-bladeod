class BladeItem extends Actor ClassGroup(BladeItems) placeable;
/* bladeitems are the smaller items that the player can hold in it's inventory
 * items like potions, keys, other buff items 
 */
 
 // name of the item
 var string                    ItemName;

//max amount of this item
var int                     MaxAmount;

// the current amount of this item
var int                     CurrentAmount;

// the texture of this item that displayed in the inventory hud 
var Texture2D               Icon;

var SkeletalMeshComponent   SkelMesh;

//sockets
var name Hand;
var vector HandLoc;

function PostBeginPlay()
{
    Super.PostBeginPlay();
    InitializeIcon();        
}

function InitializeIcon()
{
    // Checks to make sure if there is a name and an icon because if there isn't there'll be a problem
    // so give the item a generated icon and name
    if(Icon == None)
    {
        Icon = Texture2D'EngineResources.Bad';
    }
    if(ItemName == "")
    {
        ItemName = "Unnamed "$self;
    }
}

static function Texture2D GetIcon()
{
    return default.Icon;
}

static function string sGetItemName()
{
    return default.ItemName;
}    

function Tick(float DeltaTime)
{
    if(SkelMesh != None)
    {
        //SkelMesh.GetSocketWorldLocationAndRotation(Hand, HandLoc,,);
    }
}
    
	
function PickedUpBy(BladePawn P)
{
	Destroy();
}
// this is the state where the item is able to get picked up
// it's a rigid body and is not going to get destroyed
auto state OnGround
{
	function bool ValidTouch(BladePawn Other)
	{
		
	}
}

function class<BladeItem> GetClass()
{
    return class;
}

// when the player picks up an actor and its this item, it gets put to the InHand state 
// it sets the physics to PHY_None because in the pawn class, this item will get
// attached to the player left/right hand so to make it smooth, it is just set 
// to none

state InHand
{
    function Inhand()
    {
        //SetPhysics(PHYS_None);
    }
Begin:
    `log(self$"I'm in the hand of a pawn and im getting used! YAY!");
    InHand();
}
 
// the state when this item is used and is going to get thrown away and destroyed and unuseable   

defaultproperties
{
    Icon=Texture2D'BladeIcons.Icons.potionicon'
    Hand=Hand
    ItemName="ItemTest"
    bCollideActors=true
	bBlockActors=false
	
	CollisionType=COLLIDE_TouchAll
    Begin Object Class=SkeletalMeshComponent Name=ItemMeshComponent
        SkeletalMesh=SkeletalMesh'BladeInventory.Items.Item_potion500'
        PhysicsAsset=PhysicsAsset'BladeInventory.Items.Item_potion500_Physics'
    End Object
    SkelMesh=ItemMeshComponent
    Components.Add(ItemMeshComponent)  
    bProjTarget=true
    Begin Object Class=CylinderComponent Name=CollisionCylinder
        CollisionRadius=+10.0
        CollisionHeight=+10.0
        BlockActors=true
		BlockZeroExtent=true
		BlockNonZeroExtent=true
        CollideActors=true
		bAlwaysRenderIfSelected=true
    End Object
	CollisionComponent=CollisionCylinder
    Components.Add(CollisionCylinder)	
}