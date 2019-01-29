/* Blade KeyHole - Keys get put in the function open sesame and 
 * if that key is the right key, it goes through it's kismet 
 *          sequence                                        */

class BladeKeyHole extends Actor
        ClassGroup(BladeKeys,KeyHoles)
        placeable;
        
// name of this keyhole
var(KeyHole) string                    KeyHoleName;        

// name of the key that is needed to unlock this keyhole
var(KeyHole) class<BladeKey>           TheKey; 

 // is this keyhole gate locked?
var bool                    bLocked;

// only accessable by player
var BladePlayerController   PC;

function PostBeginPlay()
{
    Super.PostBeginPlay();
    bLocked=true;
}

function class<BladeKey> GetMyKey()
{
    return TheKey;
}

function OpenSesame( BladePlayerController Opener, class<BladeKey> Key)
{
	PC = Opener;
	`log("test1");
    if(bLocked)
    {   
		`log("test 2 ");
        if(Key == TheKey)
		{
			Unlock();
			`log("unlocking bitch");
		}
		
		if(Key != TheKey)
		{
			Opener.TextToHud("I don't have the key");
		}						
    }
	else if(!bLocked)
	{
		`log("This keyhole has already been unlocked");
	}
}

// unlock index 1 is unlocked
// unlock index 0 is locked
function Unlock()
{
    bLocked=false;
    TriggerEventClass(class'SeqEvent_Unlock',PC,0);
	`log("unlocking bitch part2");
    
}

defaultproperties
{
   KeyHoleName="TestKeyHole"
   TheKey=class'BladeKey_Iron'
   SupportedEvents.Empty
   SupportedEvents(0)=class'SeqEvent_Unlock'
   
   bBlockActors=true
   bCollideActors=true
   
   Begin Object class=SkeletalMeshComponent Name=KeyHoleMesh
       SkeletalMesh=SkeletalMesh'BladeInventory.Items.Item_KeyHole'
   End Object
   Components.Add(KeyHoleMesh)
   
   Begin Object Class=CylinderComponent Name=ColComp
        CollisionRadius=10.0
        CollisionHeight=10.0
        BlockActors=true
        CollideActors=true
    End Object
    Components.Add(ColComp)
   
   Begin Object Class=DynamicLightEnvironmentComponent Name=KeyHoleLightEnvironment
        bDynamic=FALSE
        bCastShadows=FALSE
    End Object
    Components.Add(KeyHoleLightEnvironment)
   
}
