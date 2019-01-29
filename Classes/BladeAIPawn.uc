class BladeAIPawn extends BladeEntity;

// The item that gets dropped when this pawn is killed
var(Item) bool                  bHasItem;

// The item of the class
var BladeItem                DroppedItem;

// The class of the item that gets dropped ( spawned )
var(Item) class<BladeItem>  DroppedItemClass;

// Number variable that gets put in to decide this pawn's power and defense, the higher the harder
var(Stats) int               FakeAgression;

// Should use bow and arrow?
var(Stats) bool             bIsArcher;

// Experience to give once this pawn has died ( by Player )
var float                   ExpToGive;

// Extra number to add in when calculating ExpToGive
var(Stats) float            ExtraExp;

var int 					MaxHealth;

var BladeWalkNode			MyWalkingNode[32];

function PostBeginPlay()
{
    Super.PostBeginPlay();
}

function Tick(float DeltaTime)
{
    Super.Tick(DeltaTime);
}

function SetWalkingNode(BladeWalkNode Node)
{
	if(MyWalkingNode[0] == None)
	{
		MyWalkingNode[0] = Node;
	}
	else if(MyWalkingNode[0] != None)
	{
		`log(self$" already has a walking node set");
	}
}	

function BladeWalkNode GetWalkNode()
{
	return MyWalkingNode[0];
}

// easy function to simply set stats like level and exp and agression
function SetStats(int inLevel, optional int inExp, optional int inFA=2)
{
    Level = inLevel;
    
    if(DroppedItemClass != None)
    {
        bHasItem = true;
    }

    ExtraExp = inExp;
 
    FakeAgression = inFA;        
    
    if((Level > 1) || (Level == 1))
    {        
        if((FakeAgression != 0) && (FakeAgression > 0))
        {
            Power = Level * FakeAgression + 10;
            Defense = Level * FakeAgression;
            ExpToGive = Level * FakeAgression + ExtraExp + Power + Defense;
			HealthMax = Level * 80 + (FakeAgression * 10);
			Health = HealthMax;
        }
    }
}    

function GiveInventory(class<BladeWeapon> Weap, optional class<BladeShield> Shield=None)
{
    if(Health > 0)
    {
		`log("Giving "$self$" a "$Weap$" and a "$Shield);
        NewWeapon(Weap);
		if(Shield != None)
		{
			NewShield(Shield);
		}
    }
}

// similar handshake for the pawn, but this is simpler for the AIpawns
function NewShield( class<BladeShield> Shield)
{
    if(CurrentShield == None) // if no shield is pres
    {
        bShieldOut = true;
        CurrentShield = GiveShield(Shield);
        CurrentShield.AttachThisTo(self);
        Mesh.AttachComponentToSocket(CurrentShield.Mesh,LeftHand);
        // you now have a shield 
    }
}

function BladeShield GiveShield(class<BladeShield> Shield)
{   
    return Spawn(Shield,,,LeftHandLoc);
}

function NoShield()
{
    if(CurrentShield != None)
    {
        CurrentShield.DetachShield(); // tells weapon to let go of this pawn
    }
    if(bShieldOut)
    {
        bShieldOut = false;
        CurrentShield = None;
        MyShield = None;
    }
    else if( CurrentShield != None || MyShield != None)
    {
        bShieldOut = false;
        CurrentShield = None;
        MyShield = None;
    }
}

function NewWeapon( class<BladeWeapon> Weap)
{
    `log("just got a new weapon");
    if(CurrentWeapon == None) // if no shield is pres
    {
        bWeaponOut = true;
        CurrentWeapon = GiveWeapon(Weap);
        CurrentWeapon.AttachThisTo(self);
        Mesh.AttachComponentToSocket(CurrentWeapon.Mesh,RightHand);
        // you now have a shield 
        `log("attaching to hand ");
    }
}

function BladeWeapon GiveWeapon(class<BladeWeapon> Weap)
{   
    return Spawn(Weap,,,RightHandLoc);
}

function NoWeapon()
{
    if(CurrentWeapon != None)
    {
        CurrentWeapon.DetachWeapon();
    }
    if(bWeaponOut)
    {
        bWeaponOut = false;
        CurrentWeapon = None;
        MyWeapon = None;
    }
    else if( CurrentWeapon != None || MyWeapon != None)
    {
        bWeaponOut = false;
        CurrentWeapon = None;
        MyWeapon = None;
    }
}
// end of weap and shield spawn functions

simulated function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
    Super.Died(Killer,DamageType,HitLocation);
	
    if(bHasItem == true)
    {
        if(DroppedItemClass != None)
        {
            DroppedItem = Spawn(DroppedItemClass,,,RightHandLoc);
            //DroppedItem.Gotostate('OnGround'); onground is its initial state
        }
        // it bHasitem is true, but there isn't a class to drop, change it to false
        if(DroppedItemClass == none)
        {
            bHasItem = false;
        }
    }
    
    if(BladePlayerController(Killer) != None)
    {
        if(ExpToGive > 0)
        {
            BladePlayerController(Killer).GiveExp(ExpToGive);
        }
        else
        {
            BladePlayerController(Killer).GiveExp(100.0);
        }       
    }
    return true;
}

function TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    Super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    `log(self$"I have taken damage, my health is now "$ Health);
}

defaultproperties
{
    ExtraExp=0
    DroppedItemClass=none;
    FakeAgression=2
    Health=100
    HealthMax=100
    GroundSpeed=150.0
    
    Begin Object Name=CollisionCylinder
        CollisionRadius=16.0
        CollisionHeight=48.000000
    End Object
	
	RightHand=RightHand
    LeftHand=LeftHand
    Swordback=Swordback
    
  //Begin Object Class=SkeletalMeshComponent Name=theSkelComponent
  //      SkeletalMesh=SkeletalMesh'BladeSkins.skins.Skin_Boxes'
  //      AnimTreeTemplate=AnimTree'BladeSkins.Anim.blade_knight_animtree1'
  //      PhysicsAsset=PhysicsAsset'BladeSkins.Phys.Skin_Boxes_Physics'
  //      AnimSets(0)=AnimSet'BladeSkins.Anim.Skin_Boxes_Anims'
  //  End Object
  //  Mesh=theSkelComponent
  //  Components.add(theSkelComponent)
}