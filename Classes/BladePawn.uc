class BladePawn extends BladeEntity notplaceable;
// to give the pawn a shield, use BladePlayerInventory::NewShield(...)

var SoundCue LevelUpSound;  // sound played when a levelup is happening

// weapons and inventory
var float MaxEnergy; // max amount of energy, higher the max the more swings you get
var float CurrentEnergy; // current energy from max, decreases with swings


var class<BladeWeapon> PendingWeapon;
var BladeWeapon SpawnedPendWeap;

var vector TraceStartLoc, TraceEndLoc; // locations of sockets used to intercept objects for pickup()
var name TraceEnd,TraceStart;

var Actor PendingKeyHole;
var BladeKey 	 PendingKey;

function PostBeginPlay()
{    
    Super.PostBeginPlay();        
    BladePlayerController(controller).Possess(Self, False);   
    `log("my current weapon is "$ CurrentWeapon $ " and my shield is "$ CurrentShield);
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
    Super.PossessedBy(C, bVehicleTransition);
    `log(Controller $" now posesses " $ self);
}

// called from PC and given its class @PlayerInv 
simulated function SetInventory(class<BladePlayerInventory> PlayerInv)
{
    if(BladePlayerInv == None && PlayerInventory == None)
    {
		`log("Setting Player Inventory to "$ PlayerInv);
        PlayerInventory = BladePlayerController(Controller).GetPlayerInvClass();
        InitializeInventories();
    }
    if(BladePlayerInv != none || PlayerInventory != None)
    {
        `log("Overwriting "$ self $ "'s inventory");
        PlayerInventory = BladePlayerController(Controller).GetPlayerInvClass();
        InitializeInventories();
    }
}

// in PC, returns spawned inventory class that was given in SetInventory()
function BladePlayerInventory GetInventory()
{
    if(BladePlayerInv != None) return BladePlayerInv;   
}

// called from SetInventory, spawns the inventory to an actor and creates its owner
function InitializeInventories()
{
    BladePlayerInv = Spawn(PlayerInventory);     
    BladePlayerInv.CreateOwner(self);  
    `Log(BladePlayerInv $ "Player Inventory loaded for " $ self);    
}
// tells pawn that it no longer has a shield in its hand
// - told by the player inventory
// - aka final handshake to cut off shield/weap and pawn
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
// DON'T USE TO JUST GIVE SHIELDS 
// use the palyerinventory function ' NewShield(...) ' 
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
    if(bShieldOut)
    {
        // put back shield, put shield in back, bring back shield
    }
    else if(!bShieldOut && CurrentShield != None)
    {
        // hands free, but put shield in back 
    }
}

function ChangeWeapon(class<BladeWeapon> InWeap)
{
	Super.ChangeWeapon(InWeap);
	`log("changing my weapon from" $ MyWeapon $ " to "$ InWeap);
	// here, the currentweapon will always be true/something 
	DetachComponent(CurrentWeapon.Mesh);
	MyWeapon = InWeap;
	CurrentWeapon = GiveWeapon(MyWeapon);
	`log("current weap is"$ currentweapon);
	Mesh.AttachComponentToSocket(CurrentWeapon.Mesh,RightHand);		
}


function NewWeapon( class<BladeWeapon> Weap)
{
    `log("just got a new weapon");
    if(CurrentWeapon == None) // if no shield is pres
    {
        bWeaponOut = true;
        CurrentWeapon = GiveWeapon(Weap);
		MyWeapon = Weap;
        CurrentWeapon.AttachThisTo(self);
        Mesh.AttachComponentToSocket(CurrentWeapon.Mesh,RightHand);
        // you now have a shield 
        `log("attaching to hand ");
    }
    else
    {
		PendingWeapon = Weap;
        if(bWeaponOut)
        {
            `log("going to toggle state");
            //GotoState('ToggleWeapon');
        }
        else if(!bWeaponOut)
        {
            // hands free, but put shield in back 
        }
    }
}

function BladeShield GiveShield(class<BladeShield> Shield)
{   
    return Spawn(Shield,,,LeftHandLoc);
}

function BladeWeapon GiveWeapon(class<BladeWeapon> Weap)
{   
    return Spawn(Weap,,,RightHandLoc);
}

function SetArmorLevel(int i)
{
    `log("set armor level called");
    if(PlayerCharInfo != None)
    {
        `log(" Setting armor level to " $ i );
        if((i == 0) || (i < 0))
        {
            Mesh.AnimSets = PlayerCharInfo.default.BladeAnimSet0;
            Mesh.SetSkeletalMesh(PlayerCharInfo.default.BladeSkeletalMesh0);
            Mesh.SetPhysicsAsset(PlayerCharInfo.default.BladePhysicsAsset0);
            Mesh.SetAnimTreeTemplate(PlayerCharInfo.default.BladeAnimTree0);
            PostInitAnimTree(mesh);
			InitializeCharacterInfo();
        }
            
        else if(i == 1)
        {
            Mesh.AnimSets = PlayerCharInfo.default.BladeAnimSet1;
            Mesh.SetSkeletalMesh(PlayerCharInfo.default.BladeSkeletalMesh1);
            Mesh.SetPhysicsAsset(PlayerCharInfo.default.BladePhysicsAsset1);
            Mesh.SetAnimTreeTemplate(PlayerCharInfo.default.BladeAnimTree1);
            PostInitAnimTree(mesh);
			InitializeCharacterInfo();
        }
        
        else if(i == 2)
        {
            Mesh.AnimSets = PlayerCharInfo.default.BladeAnimSet2;
            Mesh.SetSkeletalMesh(PlayerCharInfo.default.BladeSkeletalMesh2);
            Mesh.SetPhysicsAsset(PlayerCharInfo.default.BladePhysicsAsset2);
            Mesh.SetAnimTreeTemplate(PlayerCharInfo.default.BladeAnimTree2);
            PostInitAnimTree(mesh);
			InitializeCharacterInfo();
        }
        
        else if((i == 3) || (i > 3))
        {
            Mesh.AnimSets = PlayerCharInfo.default.BladeAnimSet3;
            Mesh.SetSkeletalMesh(PlayerCharInfo.default.BladeSkeletalMesh3);
            Mesh.SetPhysicsAsset(PlayerCharInfo.default.BladePhysicsAsset3);
            Mesh.SetAnimTreeTemplate(PlayerCharInfo.default.BladeAnimTree3);
            PostInitAnimTree(mesh);
			InitializeCharacterInfo();
        }            
    }
}

// checks if pawn's inventory class has room for any more weapons
function bool CheckWeaponRoom()
{
    `log(" weapon room check" $ bCanPickupWeapons);
    return bCanPickupWeapons; // these variables for w and s are changed by the inventory class from the function bHasRoom
}

function bool CheckShieldRoom()
{
    `log("shield room check" $ bCanPickupShields);
    return bCanPickupShields;
}
    
function Tick(float DeltaTime)
{
    Super.Tick(DeltaTime);
    
    if(Mesh != none)
    {       
        Mesh.GetSocketWorldLocationAndRotation(TraceStart, TraceStartLoc,,);
        Mesh.GetSocketWorldLocationAndRotation(TraceEnd, TraceEndLoc,,);   
    }    
	//`log(" my current state is "$ GetStateName());
    
    if(!bBlocking)
    {
        //ToggleShieldblend(false);
    }   
}

/* tell the pawn to play pickup animation, 
 * has attaching and adding items to inventories,etc 
 * @param Ac - this is the actor that is getting picked up,
 * gets attched to correct hand and correct inventory 
*/
// Time Stamp: 12/28/2015 10:06:57 PM 
// ugliest function alive for this stuff 
simulated function PickupActor(actor Ac)
{
    if(BladeItem(Ac) != None) // if an item
    {
		if(BladePotion(Ac) != None && BladePotion(Ac).bQuickPotion)
		{
			if(Health < HealthMax)
			{	
				BladePotion(Ac).HealMe(self);	
				if(Health > HealthMax)
				{
					Health = HealthMax;
				}
			}
			else
				BladePlayerController(Controller).TextToHud("I do not need it");
		}
		if(BladePotion(Ac) != None)
		{
			if(BladePotion(Ac).bQuickPotion)
			{
				BladePotion(Ac).HealMe(self);
			}
			else 
			{
			TopHalfSlot.PlayCustomAnim(PickUpAnimName, 1.0, 0.5, 0.5, false, false);       // play the anim       
			Mesh.AttachComponentToSocket(BladeItem(Ac).SkelMesh,RightHand);     // attach to righthand
			Ac.Destroy();                                                   // destroy it
			BladePlayerController(Controller).SelectedItem = None;          // since its gone, nothing is selected
			BladePlayerInv.PickupItem(BladeItem(Ac).GetClass());   
			}			// pickup the item and add it to the inventory
		}
	}

    if(BladeWeapon(Ac) != None)
    {
        BladePlayerInv.NewWeapon(BladeWeapon(ac).GetClass());     // you picked up a new weapon        
        Ac.Destroy();                               // destroy the actor on the ground                        
        BladePlayerController(Controller).SelectedItem = None;  			
    }                
        
    if(BladeShield(Ac) != None)
    {
        TopHalfSlot.PlayCustomAnim(PickUpAnimName, 1.0, 0.5, 0.5, false, false);            
        BladePlayerInv.NewShield(BladeShield(Ac).GetClass());
        Ac.Destroy();        
        BladePlayerController(Controller).SelectedItem = None;       
    }                   
    
    // the unlocking of the key hole and searching of the keyhole's key is down in the PC              
}

simulated function CheckForHitActor()
{   
    local Actor HitActor;
    local Vector HitLoc,HitNorm;
	local Vector MidOffset,HiOffset;
	MidOffset = Vect(0,0,40.0f);
	HiOffset = Vect(0,0,70.0f);
      
    if(BladePlayerController(Controller) != None)
    {                     
        HitActor = Trace(HitLoc,HitNorm,TraceEndLoc,TraceStartLoc,true);         
        DrawDebugLine(TraceStartLoc,TraceEndLoc,0,0,255,true);
		
        if(HitActor != None)
        { 
			BladePlayerController(Controller).TextToHud(" I am selecting "$ HitActor);
            BladePlayerController(Controller).SelectedItemIs(HitActor);
        }
		else
		{
			HitActor = Trace(HitLoc,HitNorm,TraceEndLoc+MidOffset,TraceStartLoc+MidOffset,true);         
			DrawDebugLine(TraceStartLoc+MidOffset,TraceEndLoc+MidOffset,255,0,0,true);
			if(HitActor != None)
			{
				BladePlayerController(Controller).TextToHud(" I am selecting "$ HitActor);
				BladePlayerController(Controller).SelectedItemIs(HitActor);
			}
			else
			{
				HitActor = Trace(HitLoc,HitNorm,TraceEndLoc+HiOffset,TraceStartLoc+HiOffset,true);         
				DrawDebugLine(TraceStartLoc+HiOffset,TraceEndLoc+HiOffset,0,255,0,true);
				if(HitActor != None)
				{
					BladePlayerController(Controller).TextToHud(" I am selecting "$ HitActor);
					BladePlayerController(Controller).SelectedItemIs(HitActor);
				}
				else
					BladePlayerController(Controller).TextToHud(" Nothing Selected");
			}
		}
    }  
}  

simulated function FindVault()
{
    local vector hitloc,hitnorm;
    local vector Zoffset;
    
    zoffset.x = Location.X;
    zoffset.y = Location.Y;
    zoffset.z = Location.Z + 300;
    
    Trace(hitloc, hitnorm, zoffset, RightHandLoc); 
    
    DrawDebugLine(Location,zoffset,0,255,0,true);
    
    return;        
}

function EnergyMath( float SwingEnergy)
{
    CurrentEnergy = CurrentEnergy - SwingEnergy;
    if((CurrentEnergy == 0) || (CurrentEnergy < 0))
    {
        YoureTired();
    }
    SetTimer(2.0,true,'EnergyRefill');
}

function EnergyRefill()
{
    local int i;
    
    i = 50;                     // needs tweaking in future
    
    if(CurrentEnergy < MaxEnergy)
    {
        
        CurrentEnergy = CurrentEnergy + i;
    }
    
    if((CurrentEnergy == MaxEnergy) || (CurrentEnergy > MaxEnergy))
    {
        CurrentEnergy = MaxEnergy;
    }
}

// you will not be able to swing, move, block,use any items, pick anything up, etc. about 1 - 3 seconds in this state
function YoureTired()
{
}
           
// ut pawn 973  
      
function ChangeWeaponRoom(bool b) // for weapons
{
    bCanPickupWeapons = b;
}

function ChangeShieldRoom(bool b) // for shields
{ 
    bCanPickupShields = b;
}

function UseFists()
{
}

function ExperienceMath(float Experience)
{    
    CurrentExperience += Experience;
    
    if((CurrentExperience == MaxExperience) || (CurrentExperience > MaxExperience) || (LeftOverExp > MaxExperience))
    {                
        if(CurrentExperience > MaxExperience)
        {
			LeftOverExp = CurrentExperience - MaxExperience;
            LevelUp();
        }
		else
		{
			LeftOverExp = 0.0f;
			LevelUp();
		}
    }    
}

simulated function OnGiveExperience(SeqAct_GiveExperience Action)
{
    local float Amount;
    
    Amount=Action.ExperienceToGive;       
    if( Amount > 0.0 ) ExperienceMath(Amount); 
}

simulated function LevelUp()
{
    local int i;
    i = 100;
    
    PowerIncrease=PowerIncrease++;
    DefenseIncrease=DefenseIncrease++;    
    Level++;                                                     
    MaxExperience=MaxExperience * 1.5;
    CurrentExperience=LeftOverExp;
    Power=Power + PowerIncrease;    
    Defense=DefenseIncrease + Defense;
    MaxEnergy=MaxEnergy * 2;    
    HealthMax = HealthMax + i;
    if( Health > 0 ) Health=HealthMax;
    
    PlaySound(LevelUpSound);
}

auto state NonCombat
{
	
Begin:
}


// no movement 
// play death anim 
state Dying
{
	function FreezeAll()
	{
		AccelRate = 0.0f;
		SetRotation(Rotation);
		SetViewRotation(Rotation);
	}	

Begin:
FreezeAll();
Controller.Unpossess();
}

simulated function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
    Super.Died(Killer,DamageType,HitLocation);   
    
    if(Controller != None)
    {
        GotoState('Dying');
    }
    return false;
}

// notes
// see Weapon
// opt - turn to weap 
// stop movement  ZeroMovementVariables()
// put weap on back
// pickup weapon 
// put in back 
// start movement default velocity ...acce..
// get current weapon back 
// done 
state ToggleWeapon
{
    function PutWeapOnBack()
    {              
        Mesh.AttachComponentToSocket(CurrentWeapon.Mesh, SwordBack);     // attach ewap to back
        // PlaySound(back sound );
    }
	function AttachWeapToHand()
	{
		Mesh.AttachComponentToSocket(CurrentWeapon.Mesh, RightHand);
		RestoreMovement();
	}
	function RestoreMovement()
	{
		AccelRate = default.AccelRate;
	}
Begin:
    BladePlayerController(Controller).TextToHud("now in toggle weapon state");
	ZeroMovementVariables(); // stop movement
	TopHalfSlot.PlayCustomAnim(TakeOutSwordAnim, 1.0, 0.5, 0.5, false, false);    // get weap
   // FinishAnim(TopHalfSlot.GetCustomAnimNodeSeq()); // on finishh
	RestoreMovement();
}

// called from TakeOutSwordAnim 
function ToggleWeaponSocket()
{
    `log(" i toggled the weapon socket");
	if(bWeaponOut) // if my weap is out 
	{
		Mesh.AttachComponentToSocket(CurrentWeapon.Mesh, SwordBack); // put on back
		bWeaponOut = false;
	}	
	else{
		Mesh.AttachComponentToSocket(CurrentWeapon.Mesh, RightHand); // put on back
		bWeaponOut = true;
	}
}

// function called by pickup function ( testing purps )
function Testing()
{
	`log("this is called from the anim_notify");
	Mesh.AttachComponentToSocket(SpawnedPendWeap.Mesh, RightHand);
}        

defaultproperties
{
	bWeaponOut=false
    PickupAnimName=blade_Pickupanim1
    UnlockAnimName=blade_unlockanim1
    TakeOutSwordAnim=blade_takeoutswordanim1
    TraceStart=TraceStart
    TraceEnd=TraceEnd
    bWalkingDead=false
    //weapons and inv 
    PlayerInventory=class'BladePlayerInventory'
    PlayerCharInfoClass=class'BoxesCharacterInformation'
    
    LeftHand=LeftHand
    RightHand=RightHand
    
    GroundSpeed=150.0
    
    // default power and defense
    Power=5
    Defense=2
    
    //default increases
    PowerIncrease=2
    DefenseIncrease=1
    Level=1
    Health=100
    HealthMax=100
    MaxExperience=500.000
    LevelUpSound=SoundCue'A_Pickups_Powerups.PowerUps.A_Powerup_Berzerk_EndCue'
    
    MaxStepHeight=15.0
    
    Begin Object Name=CollisionCylinder
      CollisionRadius=16.0
      CollisionHeight=48.000000
    End Object
    
    //Begin Object Class=SkeletalMeshComponent Name=BPawnSkeletalMeshComponent
    //    SkeletalMesh=SkeletalMesh'BladeSkins.skins.Skin_Boxes'
    //    AnimTreeTemplate=AnimTree'BladeSkins.Anim.blade_knight_animtree1'
    //    PhysicsAsset=PhysicsAsset'BladeSkins.Phys.Skin_Boxes_Physics'
    //    AnimSets(0)=AnimSet'BladeSkins.Anim.Skin_Boxes_Anims'
    //End Object
    //Mesh=BPawnSkeletalMeshComponent
    //Components.add(BPawnSkeletalMeshComponent)       
}