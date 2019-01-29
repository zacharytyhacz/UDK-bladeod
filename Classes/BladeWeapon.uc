class BladeWeapon extends UDKWeapon
    ClassGroup(BladeInventory,Weapons,Swords)
    placeable;

// hand - to connect to player's hand // end  & start - trace of the balde
var name HandSocket, EndSocket, StartSocket;

// socket it attachs to on the player/awpn
var name AttachSocket; 

// hand - to connect to player's hand // end  & start - trace of the balde
var vector HandSocketLoc, EndSocketLoc, StartSocketLoc; 

// damage of the sword, added with player damage = damage on enemy
var int PowerDamage;  

// amount of points it removes from the holder's defense
var int DefenseDamage; 

// on ground or on player?
var bool bIsHeld; 

// amount of energy subtracted to prevent spam swing
var float SwingEnergy; 

// make sure a swing doesn't mega hit the actor every tick just because it is in the actor ( buggy)
var array<Actor> HitArray; 

// Name of the weapon
var string WeaponName;

// minimum level to use special attack
var int MinLevel; 

// the animation to call when performing it's special attack ( mega damage )
var name SpecialAttackAnim; 

var class<BladeDamageType> MyDamageType;

// the pawn that is holding the weapon
var BladePlayerController PC;

var() int MaxSwings;

// HUD texture for the weapon
var Texture2D WeaponIcon;

static function Texture2D GetWeaponIcon()
{
	return default.WeaponIcon;
}

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
}

simulated state Swinging extends WeaponFiring
{
    simulated event Tick(float DeltaTime)
    {
        Super.Tick(DeltaTime);
        TraceSwing();
    }
    
    simulated event EndState(Name NextStateName)
    {
        Super.EndState(NextStateName);
        SetTimer(GetFireInterval(CurrentFireMode), false, nameof(ResetSwings));
    }
Begin:
    `log("I am in the Swinging State");
}

function RestoreAmmo(int Amount, optional byte FireModeNum)
{
   MaxSwings = default.MaxSwings;
}

function ConsumeAmmo(byte FireModeNum)
{
   if (HasAmmo(FireModeNum))
   {
      MaxSwings--;
   }
}

simulated function bool HasAmmo(byte FireModeNum, optional int Ammount)
{
   return MaxSwings > Ammount;
}

function ResetSwings()
{
    RestoreAmmo(MaxSwings);
}

function class<BladeWeapon> GetClass()
{
    return class;
}

function tick(float deltatime)
{
    super.tick(deltatime);
    GetSockets();
    //`log("current state is " $ GetStateName());
}

function GetSockets()
{
    SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation(StartSocket,StartSocketLoc,,);
    
    SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation(EndSocket,EndSocketLoc,,);
    
    //SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation(HandSocket,HandSocketLoc,,);
}

simulated function FireAmmunition()
{
   StopFire(CurrentFireMode);
   HitArray.Remove(0, HitArray.Length);

   if (HasAmmo(CurrentFireMode))
   {
      super.FireAmmunition();
   }
}

function bool AddToHitArray(Actor HitActor)
{
    local int i;
    for ( i = 0; i < HitArray.Length; i++)
    {
        if (HitArray[i] == HitActor)
        {
            return false;
        }
    }
    HitArray.AddItem(HitActor);
    return true;
}

function TraceSwing()
{
    local Actor HitActor;
    local vector HitLocation, HitNormal, Momentum;
    //local BladeShield aShield;        
    `log("do i get here");
    DrawDebugLine(StartSocketLoc,EndSocketLoc,255,0,0,true);
    
    foreach TraceActors(class'Actor', HitActor, HitLocation, HitNormal, StartSocketLoc,EndSocketLoc)
    {
        `log("foreach trace actors started");
        if (HitActor != self && AddToHitArray(HitActor) == true)
        {
            `log("trace actors initiated");
            if(BladeEntity(HitActor) == None)
            {                
                `log("I am hitting " $ HitActor);
                Momentum = Normal(StartSocketLoc - EndSocketLoc) * InstantHitMomentum[CurrentFireMode];
                HitActor.TakeDamage(PowerDamage, Instigator.Controller, HitLocation, Momentum, MyDamageType);
                
                if(Instigator.Controller == PC)
                {
                    `Log("my holder is a player");
                }
           }                     
        }
    }
}

// Remove from inventory and detach from hand
simulated event Destroyed()
{
    Super.Destroyed();
    //DetachWeapon();
    
    if(BladePawn(instigator) != None)
    {
        //BladePawn(Instigator).BladePlayerInv.DropWeapon(class);
    }
}

simulated function DetachWeapon()
{   
    if(BladeEntity(Instigator) != None)
    {
        BladeEntity(Instigator).DetachComponent(Mesh);
        
        if(BladePawn(Instigator) != None)
        {
            //BladePawn(Instigator).BladePlayerInv.DropWeapon(class);
        }
        Instigator = None;
        //GoToState(Idle);
        // set phys 
    }
}
    
simulated function AttachThisTo(BladeEntity TheHolder)
{
    if(Mesh != none)
    {
        Instigator = TheHolder;
        
        GoToState('Active');
        
        `log(self$"'s instigator is "$ Instigator);
        
    }
}

defaultproperties
{
    MaxSwings = 999;
    
    bMeleeWeapon=true;
    bInstantHit=true;
    FiringStatesArray(0)="swinging"
    
    WeaponFireTypes(0)=EWFT_Custom

    MyDamageType=class'BladeDamageType'
    HandSocket=RightHand
    StartSocket=Base
    EndSocket=Tip
    
    WeaponName="BladeTestSword"
    MinLevel=1
    PowerDamage=5
    DefenseDamage=-2
    SwingEnergy=10
    bHidden=false
	
    bProjTarget=true
    bCollideActors=true
    bBlockActors=false
    CollisionType=COLLIDE_TouchAll
	
    Begin Object Class=SkeletalMeshComponent  Name=WeaponMesh
        SkeletalMesh=SkeletalMesh'BladeInventory.Swords.Sword_knightsword'
        PhysicsAsset=PhysicsAsset'BladeInventory.Swords.Sword_knightsword_Physics'
        Scale=1.0
        HiddenGame=false
        CollideActors=true
        BlockActors=true
        PhysicsWeight=0
        bHasPhysicsAssetInstance=true
        BlockRigidBody=true
        bUpdateSkelWhenNotRendered=false
    End Object
    Mesh=WeaponMesh
    Components.Add(WeaponMesh)
    
    RemoteRole=ROLE_AUTHORITY
    
    Begin Object Class=CylinderComponent Name=CollisionComponent
        CollisionRadius=8.0
        CollisionHeight=24.00
        BlockActors=true
        CollideActors=true
    End Object
    Components.add(CollisionComponent)  
}
   
        
 