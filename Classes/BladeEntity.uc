// parent for all blade pawns and entities //
class BladeEntity extends Pawn notplaceable;

// An invisible copy of the skeletal mesh that can have a material put on it to create effects(ice, fire, etc)
var SkeletalMeshComponent EffectMesh;

// The pawn's power, it gets added to the pawn's weapon to give extra damage ( the player's power and defense increase with level up )
var int Power;

// Damage that gets shaved off when taking damage
var int Defense;

// Pawn's hands, for shields and weapons and items
var name RightHand,LeftHand, SwordBack; // sockets for picking up weapons,items,shields,etc
var vector RightHandLoc, LeftHandLoc, SwordBackLoc;

// Is this pawn Poisoned?
var bool bIsPoisoned;

// is this pawn a living dead creature?
var bool bWalkingDead;

// How many times has this pawn been hit with Poison?
var int PoisonTimes;

// How much damage should the Poison do the pawn?
var int PoisonDamage;

// Can this pawn be Poisoned?
var(Stats) bool bCanBePoisoned;

// How experienced is this pawn?
var(Stats) int Level;

// When the pawn is blocking, when a weapon hits a bladeshield and the shield's holder is blocking, the pawn can protect itself
var bool bBlocking;

// The Instance of the pawn's shield
var BladeShield CurrentShield;

// The Shield that this pawn is carrying
var(Inventory) class<BladeShield> MyShield;

// The Instace of the pawn's weapon
var BladeWeapon CurrentWeapon;

// The Weapon that this pawn is carrying
var(Inventory) class<BladeWeapon> MyWeapon;

var bool bWeaponOut;        // my weapon is currently in my hand right now
var bool bShieldOut;        // my shield is current in my hand rightnow

var class<BladeSoundInfo> SoundInfo;

var Texture2D FaceIcon;

// Character information, holds info about anims,meshes,armor levels, etc.
var class<BladeCharacterInformation> PlayerCharInfoClass;
var BladeCharacterInformation PlayerCharInfo;

var name TakeOutSwordAnim;
var name TakeOutShieldAnim;
var name PickUpAnimName;
var name UnlockAnimName;

var BladeAnimBlendByCombat          CombatBlend; // am i in combat( 0 ) or not(1)?
var BladeAnimBlendByWeaponState     WeaponStateBlend; // are my weaps out or nah?
var BladeAnimBlendByShield          ShieldBlend; // may not be blended, maybe child bone blended
var AnimNodeBlend       			ShieldBlendPerBone;

var AnimNodeSlot TopHalfSlot;

function PostBeginPlay()
{
    Super.PostBeginPlay(); // refill everything at the beginning of the 
    
    if(FaceIcon == None)
    {
        FaceIcon = Texture2D'BladeIcons.Icons.face_trollface';
    }  
}

// function jsut for changing weapons, not giving, these weapons already exist
function ChangeWeapon(class<BladeWeapon> InWeap)
{
	//do animation 
	// destroy current weapon 
	// current weapon = spawn(inweap), myweap = inweap
	// spawn inWeap, attach inweap to right hand 
}

function ChangeShield(class<BladeShield> InShield)
{
	//
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    if(SkelComp == Mesh)
    {
        TopHalfSlot = AnimNodeSlot(Mesh.FindAnimNode('TopHalfSlot'));    
        //`log(" my tophalf slot is " $ TopHalfSlot);
        
        //FeignDeathBlend = AnimNodeBlend(Mesh.FindAnimNode('FeignDeathBlend'));
        CombatBlend = BladeAnimBlendByCombat(Mesh.FindAnimNode('CombatBlend'));
        `log(" my combatblend is " $ CombatBlend);
        
        WeaponStateBlend = BladeAnimBlendByWeaponState(Mesh.FindAnimNode('WeaponsState'));
        //`log(" my weaponstateblend is " $ WeaponStateBlend);
        
        ShieldBlend = BladeAnimBlendByShield(Mesh.FindAnimNode('ShieldBlend'));
        `log(" my shielblend  is " $ ShieldBlend);
       
        // if (FeignDeathBlend != None && FeignDeathBlend.Children[1].Anim != None)
        //{
        //    FeignDeathBlend.Children[1].Anim.PlayAnim(false, 1.1);
        //}
    }
}

function ShieldBlock(bool block)  // function that makes the pawn block
{
    local string str;
    `log("shield block "$ block);
    str = "You do not have a shield";
    if(CurrentShield != None)
    {
        if(block)
        {       
            if(!bBlocking) // check if we are not blocking 
			{
				if((ShieldBlend != None) && (ShieldBlend.Children[0].Anim != None))
				{
					//ShieldBlend.Children[0].Anim.PlayAnim(false,1.0);
					ShieldBlend.SetActiveChild(0,0.1); // play blocking anim 
					ShieldBlend.PlayAnim(false,1.0,0);
					//`LOG("shield do you get here");
					bBlocking = true; // you are now blocking
					GroundSpeed = GroundSpeed/2;	
				}  
			}
        }   
        
        else
        {
            if(bBlocking)
			{
				if((ShieldBlend != None) && (ShieldBlend.Children[1].Anim != None))
				{
					//`LOG("shield do you get here");
					//ShieldBlend.Children[1].Anim.PlayAnim(false,1.0);
					ShieldBlend.SetActiveChild(1,0.1);
					ShieldBlend.PlayAnim(false,1.0,0);
					bBlocking = false;
					GroundSpeed = default.GroundSpeed;
				}
			}
			else if(!bBlocking)
			{
				if((ShieldBlend != None) && (ShieldBlend.Children[1].Anim != None))
				{
					//`LOG("shield do you get here");
					//ShieldBlend.Children[1].Anim.PlayAnim(false,1.0);
					ShieldBlend.SetActiveChild(1,0.1);
					//ShieldBlend.PlayAnim(false,1.0,0);
					bBlocking = false;
					GroundSpeed = default.GroundSpeed;
				}
			}
        }
    }       
    else if(CurrentShield == None)
    {
        BladePlayerController(Controller).TextToHud(str);
    }               
}

// called from PC when executing ToggleCombat via keypress @param bEngage is the toggle bool
// Pawn goes into combat mode, the PAWN will be able to dodge, swing percisely, target and rotate around target
function CombatMode(bool bEngage)
{
	`log("combatmode "$ bEngage);
    if(bEngage)
    {
        if((CombatBlend != None) || (CombatBlend.Children[0].Anim != None))
        {
            CombatBlend.PlayAnim(true,1.0f,0.0f);
			CombatBlend.SetBlendTarget(1.f, 0.1f);
			`log("Enabling Combat Mode for "$ self);
        }
    }    
    else
    {
        if((CombatBlend != None) || (CombatBlend.Children[1].Anim != None))
        {
			CombatBlend.SetBlendTarget(0.f, 0.1f);
            `log("Disabling Combat Mode for "$ self);
        }
    }
}

// called from PC
function InitializeCharacterInfo()
{
    PlayerCharInfo = Spawn(PlayerCharInfoClass);
    `Log(PlayerCharInfo $ "Player Character Information loaded for " $ self);
    ShieldBlock(false);
    CombatMode(false);
}

function Tick(float DeltaTime)
{
    Super.Tick(deltatime);
    
    if (Mesh != None)
    {
        Mesh.GetSocketWorldLocationAndRotation(RightHand, RightHandLoc,,);
        Mesh.GetSocketWorldLocationAndRotation(LeftHand, LeftHandLoc,,);
        Mesh.GetSocketWorldLocationAndRotation(swordback, swordbackloc,,);
    }
}

function ImPoisoned(int pDamage) // will be called from a Poison damage type
{
    local float DamageInterval; // the amount of time between decreases of health   // the amount of health to lose every interval
    local int i;
    
    PoisonTimes++;              // each time the player gets hit with Poison, this goes up increasing its multiplier
    bIsPoisoned = true;
    
    if(bIsPoisoned)
    {
        if((PoisonTimes > 0) && (PoisonTimes < 5))
        { 
            // Poison damage if the amount of takendamage divided by 12. so if you are hit for 120, you will get Poison damage for 10;
            i = pDamage / 2 ; 
            PoisonDamage += pDamage / 12 * PoisonTimes; 
            DamageInterval = i / 2; // interfal of seconds. if you are hit for 120( a lot) you lose 10 health every 3 seconds
        }
        if(PoisonTimes > 5)
        {
            PoisonTimes = 5;
            
            i = pDamage / 2 ; 
            PoisonDamage += pDamage / 12 * PoisonTimes; 
            DamageInterval = i / 2;
        }        
        SetTimer(DamageInterval,true,'PoisonDamageMe');
    }
	else
    {
        StopPoison();
        return;
    }
}
   
function PoisonDamageMe()
{
    local int oldtimes;
    
    oldtimes = PoisonTimes;
    
    if(Health > 0)
    {
        Health -= PoisonDamage;   
        if(PoisonTimes == oldtimes)
        {
            SetTimer(PoisonTimes*20,false,'StopPoison');
        }
        /* if the player is hit again, clear the timer and start over again */
        else if(PoisonTimes != oldtimes)
        {
            ClearTimer('StopPoison');
            SetTimer(PoisonTimes*2,false,'StopPoison');
            
        }
    }    
    // when the player dies from Poison,
	//there is a pause from the poison damage keep going, so this check 
    // helps with bugs
    else
    {
        StopPoison();
    }
}

function StopPoison()
{
    PoisonDamage=0;
    PoisonTimes=0;
    bIsPoisoned=false;
    ClearTimer('StopPoison');
    ClearTimer('PoisonDamageMe');
}
//3551
//simulated function SetEffectMaterial(MaterialInterface MatInst)

function TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	`log("@@@@@@@@@@@@@@@@@@@@@@@ I TOOK DAMAGE");
	if(BladeAI(Controller) != None)
	{
		`log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ I am a bot and i took damage");
	}
    // Bring this entity's defense into action
    if(Damage > 0)
    {
        Damage -= Defense;
        
    }
    
    if(DamageType == class'BladeDamagePoison')
    {
        ImPoisoned(Damage);
    }
    // Fire Damage leaves the hitactor's defense out of the equation
    else if(DamageType == class'BladeDamageFire')
    {
        if(Damage > 0)
        {
            Damage += Defense;
        }
    }    
    // Vampire Damage gives the instigator a fraction of the damage given to the hitpawn.
    else if(DamageType == class'BladeDamageVampire')
    {
        if(Damage > 4)
        {
            InstigatedBy.Pawn.Health += Damage / 4;
        }
    }    
    // Ice damage does a bit more damage to dead pawns
    else if(DamageType == class'BladeDamageIce')
    {
        if(bWalkingDead) // if this pawn is walking dead 
        {
            Damage += Damage/2;
        }
    }
    Super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}

simulated function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
    if (Super.Died(Killer, DamageType, HitLocation))
    {
        Mesh.MinDistFactorForKinematicUpdate = 0.f;
        Mesh.SetRBChannel(RBCC_Pawn);
        Mesh.SetRBCollidesWithChannel(RBCC_Default, true);
        Mesh.SetRBCollidesWithChannel(RBCC_Pawn, false);
        Mesh.SetRBCollidesWithChannel(RBCC_Vehicle, false);
        Mesh.SetRBCollidesWithChannel(RBCC_Untitled3, false);
        Mesh.SetRBCollidesWithChannel(RBCC_BlockingVolume, true);
        Mesh.ForceSkelUpdate();
        Mesh.SetTickGroup(TG_PostAsyncWork);
        CollisionComponent = Mesh;
        CylinderComponent.SetActorCollision(false, false);
        Mesh.SetActorCollision(true, false);
        Mesh.SetTraceBlocking(true, true);
        SetPhysics(PHYS_RigidBody);
        Mesh.PhysicsWeight = 1.0;

        if (Mesh.bNotUpdatingKinematicDueToDistance)
        {
          Mesh.UpdateRBBonesFromSpaceBases(true, true);
        }

        Mesh.PhysicsAssetInstance.SetAllBodiesFixed(false);
        Mesh.bUpdateKinematicBonesFromAnimation = false;
        Mesh.SetRBLinearVelocity(Velocity, false);
        Mesh.ScriptRigidBodyCollisionThreshold = MaxFallSpeed;
        Mesh.SetNotifyRigidBodyCollision(true);
        Mesh.WakeRigidBody();

        return true;
    }
    
    if(CurrentWeapon != None)
    {
        CurrentWeapon.DetachWeapon();
    }
    if(CurrentShield != None)
    {
        CurrentShield.DetachShield();
    }
    
    // death sounds
    if(DamageType == class'BladeDamageFire') PlayerCharInfo.BladeSoundInfo.static.PlayFireDeathSound(self);
    else if(DamageType == class'BladeDamageIce')  PlayerCharInfo.BladeSoundInfo.static.PlayIceDeathSound(self);
    else if(DamageType == class'BladeDamagePoison') PlayerCharInfo.BladeSoundInfo.static.PlayPoisonDeathSound(self);
    else if(DamageType == class'BladeDamageVampire') PlayerCharInfo.BladeSoundInfo.static.PlayVampireDeathSound(self);     
    else PlayerCharInfo.BladeSoundInfo.static.PlayDeathSound(self);
    return Super.Died(Killer, DamageType, HitLocation);
}

defaultproperties
{
    RightHand=RightHand
    LeftHand=LeftHand
    Swordback=Swordback
    
    Health=100
    HealthMax=100
    
    FaceIcon=Texture2D'BladeIcons.Icons.face_trollface'
    
    Begin Object Class=SkeletalMeshComponent Name=BPawnSkeletalMeshComponent
        SkeletalMesh=SkeletalMesh'BladeSkins.skins.Skin_Boxes'
        AnimTreeTemplate=AnimTree'BladeSkins.Anim.blade_knight_animtree1'
        PhysicsAsset=PhysicsAsset'BladeSkins.Phys.Skin_Boxes_Physics'
        AnimSets(0)=AnimSet'BladeSkins.Anim.Skin_Boxes_Anims'
        bHasPhysicsAssetInstance=true
        BlockRigidBody=TRUE
        RBCollideWithChannels=(Untitled3=true)
    End Object
    Mesh=BPawnSkeletalMeshComponent
    Components.add(BPawnSkeletalMeshComponent)
}