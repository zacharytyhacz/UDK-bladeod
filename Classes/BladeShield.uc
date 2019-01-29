// the shield is a pickup that can be used to defend oneself from taking damage
// can break from taking damage
// similar to weapon

class BladeShield extends Actor
    ClassGroup(BladeInventory,Shields)
    placeable;
    
var name HandSocket;

var vector HandSocketLoc;

// the starting health of the shield 
var int SMaxHealth; 

// less than max health
var int SCurrentHealth; 

// name of the shield
var string ShieldName;

// when equiped, this is how much extra power it give the player ( usually 1 - 5 )
var int PowerIncrease;

// the bladepawn that current holds this shield
var BladePawn Holder;

// the bladepawn's shieldinventory actor class
var BladePlayerInventory HolderInventory;

// whether shield is broken or not, meaning if it can be picked up or not
var bool bBroken;

// the sound of the shield being hit
var SoundCue ShieldHitSound;

// shield mesh component
var MeshComponent Mesh;

// for smooth inventory systematics
var class<BladeShield> ShieldClass;

// the break animation of the shield breaking into peices and falling
//var(Animations) name BreakAnimation; 
    
function PostBeginPlay()
{
    Super.PostBeginPlay();
    
    SCurrentHealth = Default.SMaxHealth; // we want the health of the shield to be refilled at the beginning of the levle
}

function Tick(float DeltaTime)
{
    SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation(HandSocket, HandSocketLoc,,); 
}
    
function class<BladeShield> GetClass()
{
    return class;
}

auto state OnGround
{
    function SetOnGround()
   {
       if(!bBroken)
       {
            SetPhysics(PHYS_RigidBody);            
       }
    
       if(bBroken) 
       {
           SetPhysics(PHYS_None);
       }
       
   }
}

state InHand
{ 
    function InHand()
   {
       SetPhysics(PHYS_None);
   }
}

//@param Instigator - for kill names
//@param HitDamage - int gets put in here from weapon 

function GetHit(int HitDamage, Controller HitDamager)
{
    local int i;
     
    if( HitDamage >= SCurrentHealth )       // if the damage is greator or equal to the health
    {
        i = Abs(HitDamage - SCurrentHealth);       // get left over damage ( i ) + make it positive 
        ShieldBreak(i, HitDamager);         // it breaks and add the remainning damage to the holder
        PlaySound(ShieldHitSound);          // 'insert shield break sound and anim here'
    }        
    
    if ( HitDamage < SCurrentHealth )
    {
        SCurrentHealth = SCurrentHealth - HitDamage;        // take away health from the current health
        PlaySound(ShieldHitSound);
    }
}

function ShieldBreak(int LeftOverDamage, Controller HitDamager)
{
    local vector m;
    
    if (Holder != none)
    {    
        Holder.TakeDamage(LeftOverDamage,HitDamager,Holder.LeftHandLoc,m,class'UTGame.UTDmgType_Instagib'); // give the holder left over damage, at the holder's left arm/hand
        HolderInventory.DropShield(ShieldClass); // remove the shield from player
        bBroken=True; // it is broken
        GoToState('OnGround'); // it is back on the ground;    
    }
    
}

simulated function DetachShield()
{   
    if(BladeEntity(Instigator) != None)
    {
        BladeEntity(Instigator).DetachComponent(Mesh);
        
        if(BladePawn(Instigator) != None)
        {
            BladePawn(Instigator).BladePlayerInv.DropShield(class);
        }
        Instigator = None;
        //GoToState(Idle);
        // set phys 
    }
}     

// copied from the bladeweapon class because THIS WORKS1111
simulated function AttachThisTo(BladeEntity TheHolder)
{
    //TheHolder = BladeEntity(Instigator);
    if(Mesh != none)
    {
        //`log(" ATTACH THIS TO FUNCTION HAS BEEN ACTIVATED ##################################### ");
        TheHolder.Mesh.AttachComponentToSocket(Mesh, TheHolder.LeftHand);
        //`log(self$"'s instigator is "$ Instigator);
        //`log(self$"'s hodler is "$ TheHolder);
        
        GotoState('InHand');
    }
}

defaultproperties
{
    Begin Object class=SkeletalMeshComponent Name=ShieldMesh
        SkeletalMesh=SkeletalMesh'BladeInventory.Shields.Shield_WoodenShield'
        PhysicsAsset=PhysicsAsset'BladeInventory.Shields.Shield_WoodenShield_Physics'
        HiddenGame=false
        CollideActors=true
        BlockActors=true
        PhysicsWeight=0
        bHasPhysicsAssetInstance=true
        BlockRigidBody=true
        bUpdateSkelWhenNotRendered=false
    End Object
    Mesh=ShieldMesh
    Components.Add(ShieldMesh)
    
    bProjTarget=true
    bCollideActors=true
    bBlockActors=false
    CollisionType=COLLIDE_TouchAll
	
    Begin Object Class=CylinderComponent Name=CollisionComponent
        CollisionRadius=20.0
        CollisionHeight=20.0
        BlockActors=true
        CollideActors=true
    End Object
    Components.add(CollisionComponent) 
    
    bHidden=false
    
    ShieldHitSound=SoundCue'A_Pickups_Powerups.PowerUps.A_Powerup_Berzerk_EndCue'
    ShieldClass=class'BladeShield'
    SMaxHealth=100
    ShieldName="Test Shield"
    HandSocket=LeftHand
}