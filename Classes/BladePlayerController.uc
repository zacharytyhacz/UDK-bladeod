class BladePlayerController extends GamePlayerController
    dependson(BladePawn);

var Actor                           SelectedItem;

var BladePlayerInventory            PlayerInv;
var bool                            bAlreadySwitching;

// for now, only allowed to lock onto AIpawns
var BladeAIPawn                     LockTarget;
var BladeAIPawn                     PendingTarget;

// this is a list for handling mulitple lock targets 
var array<BladeAIPawn>              LockedTargets;

var int                             AmountTargets;

var bool                            bLockedOn;

var bool                            bCombat;

var float CurrentExperience;
var float MaxExperience; // once this max is reached, a levelup() will occur
var float LeftOverExp; // this is a helper, when gained experience goes over the max, it is saved here and added toward next level

var int PowerIncrease,DefenseIncrease;

var class<BladePlayerInventory>     PlayerInvClass;
var BladePlayerInventory 			BladePlayerInv;

var class<BladeWeapon>				PendingWeapon;
var BladeWeapon 					SpawnedPendWeap;

var class<BladeShield>				PendingShield;
var BladeShield						SpawnedPendShield;

var bool bCanPickupWeapons; // if there is space in the inventory, i can pickup weaps
var bool bCanPickupShields; // if there is space, i can pickup shields

var vector TraceStartLoc, TraceEndLoc; // locations of sockets used to intercept objects for pickup()
var name TraceEnd,TraceStart;

var Actor PendingKeyHole;
var BladeKey 	 PendingKey;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
}

// This PC sets the player's inventory and initalizes their char info
function Possess(Pawn aPawn, bool bVehicleTransition)
{   
    aPawn.PossessedBy(Self, False);    
    bCombat = false;       
    Super.Possess(aPawn, bVehicleTransition); 
    
    if(BladePawn(aPawn) != None)
    {
        BladePawn(Pawn).SetInventory(PlayerInvClass);
        PlayerInv = BladePawn(Pawn).GetInventory();
        BladePawn(Pawn).InitializeCharacterInfo();
    } 
}

simulated function class<BladePlayerInventory> GetPlayerInvClass()
{
    return PlayerInvClass;
}
// Main use function
// checks for the item and depending on what the 
// item is, it runs through different checks like space
// and level and correct stats and runs different animations
exec simulated function BladeUse()
{       
    local class<BladeKey> aClass;
    
    if(!bCombat)
    {
        BladePawn(Pawn).CheckForHitActor();
           
        if(BladeItem(SelectedItem) != None)
        {
            BladePawn(pawn).PickupActor(SelectedItem);
            TextToHud(BladeItem(SelectedItem).ItemName);
        }            
        
        if(BladeWeapon(SelectedItem) != None)
        {
            //TextToHud(BladeWeapon(SelectedItem).WeaponName);
            
            if(BladePawn(pawn).CheckWeaponRoom() == true)
            {
                BladePawn(pawn).PickupActor(SelectedItem);
                TextToHud("new weapon");
            }
        }
        
        if(BladeShield(SelectedItem) != None)
        {       
            if(BladePawn(pawn).CheckShieldRoom() == true)
            {
                BladePawn(pawn).PickupActor(SelectedItem);
                TextToHud(BladeShield(SelectedItem).ShieldName);
            }
        }
           
        if(BladeKeyHole(SelectedItem) != None)
        {
            if(PlayerInv != None)
            {
                aClass = BladeKeyHole(SelectedItem).GetMyKey(); // get the key thats needed     
                if(aClass != None)
                {
                    `log(" needed class = "$ aClass $"| my player inv = "$ PlayerInv $ " | do i have the key = " $ PlayerInv.FindItem(aClass));
                    if(PlayerInv.FindItem(aClass)) // if the player's inv has it.....
                    {                                       
                        `log(" opensesame() and animation function");
                        BladeKeyHole(SelectedItem).OpenSesame(self, aClass); // open dat up
                        BladePawn(Pawn).SetKeyHole(SelectedItem);
                        BladePawn(Pawn).SetKey(aClass);
                        BladePawn(Pawn).GoToState('Unlocking');
                    }           
                    else
                    {
                        TextToHud("I do not have the key");
                    }
                }
            }          
        }
        
        if(SelectedItem == None)
        {
            
        }
    }
    else
    {
        // do not pickup anything while in copmbat
    }
}

exec function UseShield(bool bBlock)
{
    `log(" ayo is'a dis'a working?");
    if((Pawn != None) && (BladePawn(Pawn) != None))
    {
        BladePawn(Pawn).ShieldBlock(bBlock);
    }
}

exec function StartSwing()
{

}

/*
exec simulated function wIsPressed(bool IsPressed)
{
    if(BladePlayerInput(PlayerInput) != None)
    {
        BladePlayerInput(PlayerInput).ChangewPressed(IsPressed);
    }
}

exec simulated function aIsPressed(bool IsPressed)
{
    if(BladePlayerInput(PlayerInput) != None)
    {
        BladePlayerInput(PlayerInput).ChangeaPressed(IsPressed);
    }
}

exec simulated function sIsPressed(bool IsPressed)
{
    if(BladePlayerInput(PlayerInput) != None)
    {
        BladePlayerInput(PlayerInput).ChangesPressed(IsPressed);
    }
}

exec simulated function dIsPressed(bool IsPressed)
{
    if(BladePlayerInput(PlayerInput) != None)
    {
        BladePlayerInput(PlayerInput).ChangedPressed(IsPressed);
    }
}
*/
function SelectedItemIs(Actor A)
{
    SelectedItem = A;
    BladeHUD(myhud).Get2DLocationOf(SelectedItem.Location,"Item");
}

function LockRotation(bool bLock)
{
    if(bLock)
    {
        `log("pawn is locked on target");
        Pawn.SetViewRotation(rotator(LockTarget.Location - Pawn.Location));
        //Pawn.SetViewRotation(rotator(LockTarget.Location - Pawn.Location));
        //SetRotation(Pawn.GetViewRotation()); // set self rotation to pawn's
        // ^ ^ ^ ^ dont need this because the pawn's set function does it for its controller
        DrawDebugLine(Pawn.Location,LockTarget.Location,0,0,255,false); 
        // at this point the palyer SHOULD be lockedon  
    }
    else if(!bLock)
    {
        Pawn.SetViewRotation(Pawn.Rotation);
    }
} 

function PlayerTick(float DeltaTime)
{
    Super.PlayerTick(DeltaTime);
    if(bLockedOn)
    {
        LockRotation(true); 
    }   
    else
    {
        LockRotation(false);
    }
}

function TextToHud(string s) // simple helper function 
{
    BladeHUD(myhud).SetShownText(s);
}

exec function ToggleWeapon()
{
    if(BladePawn(Pawn) != None)
    {
        if(BladePawn(Pawn).CurrentWeapon != None)
        {
            BladePawn(Pawn).GoToState('ToggleWeapon');
        }
    }
}

exec simulated function SwitchWeapon()
{   
    `log("I am switching weapons");
    //BladeHUD(myhud).NowSwitching(true);
    if(PlayerInv != None)
    {
        PlayerInv.NextWeapon(1);    
    }
    else if(PlayerInv == None)
    {
        `warn("Unable to switch weapon, no player inventory present in "$ Pawn @" my playerinventory is "$ PlayerInv);
    }
}
//a = A.location;
//b = B.location
//A.SetRotation(rotator(b - a));

// - notes 
// check to see if any enemies are in front of player 
// put enemy portrait on top screen - show health and level 
// engage player pawn, lock rotation onto enemy 
// put player pawn into animations and state 
// disable bladeuse()
// when enemy dies, leave state, if other enemy is present, lock onto that one 
exec function ToggleCombat()
{
    local int i;
    
    bCombat = !bCombat; // toggle if im in combat or not
    
    `log("##########################################"$ bCombat @ "######"@ bLockedOn);
    if(BladePawn(Pawn) != None)
    {
        if(bCombat)
        {
            foreach WorldInfo.AllPawns(class'BladeAIPawn', PendingTarget)
            {
                if(PendingTarget != None)
                {
                    `log(" did fast trace");
                    if(FastTrace(PendingTarget.Location, Pawn.Location)) // if nothing inbetween
                    {
                        if(PendingTarget.Health > 0) // if that targets not dead 
                        {                       
                            LockedTargets.AddItem(PendingTarget); // add to lock targets
                            `log(" the pending target is "$PendingTarget);
                        }
                    }
                }
            }
            if(BladePawn(Pawn).Health > 0 && BladePawn(Pawn) != None) // if my pawn is not dead and not nothing
            {
                AmountTargets = LockedTargets.Length;                       // add to my locktargets of death list
                if(AmountTargets == 1 || AmountTargets > 1)                     // just a double check, will always work tho
                {
                    BladePawn(Pawn).CombatMode(true);                   // gets Pawn set for combat           
                    bLockedOn = true;                       // this gets set and the Tick catches it, locking the target 
                    `log(" lock target = " $ LockedTargets[0]);  
                    LockTarget = LockedTargets[0]; // find the first enemy in the array       
                    BladeHUD(myhud).SetTargetIcon(LockTarget.FaceIcon,LockTarget.Level,LockTarget.Health);                      
                }
				//for(
            }
        }
        
        else if(!bCombat)
        {
            for(i = 0; i < LockedTargets.Length; i++)
            {
                LockedTargets.RemoveItem(LockedTargets[i]);
            }
            bLockedOn = false;
            LockTarget = None;
            AmountTargets = 0;
            PendingTarget = None;
            BladePawn(Pawn).CombatMode(false);
            BladeHUD(myhud).RemoveTargetIcon();         
        }
    }
}

state BladeWalking extends PlayerWalking
{
Begin:
}

simulated function SetKey(class<BladeKey> TheKey)
{
	PendingKey = Spawn(TheKey,,,RightHandLoc);
}
simulated function SetKeyHole(actor BKH)
{
	PendingKeyHole = BKH;
}
state Unlocking
{
    function TurnToKeyHole()
    {     
		BladePawn(Pawn).SetViewRotation(rotator(PendingKeyHole.Location - BladePawn(Pawn).Location));
    }
Begin:
    BladePawn(Pawn).ZeroMovementVariables();
	TurnToKeyHole();
	BladePawn(Pawn).Mesh.AttachComponentToSocket(PendingKey.SkelMesh, RightHand);
	//TopHalfSlot.PlayCustomAnim(UnlockAnimName, 1.0, 0.5, 0.5, false, false);
	PendingKey.Destroy();
	GotoState('NonCombat');
	
}

simulated function GiveExp(float Amount)
{
    BladePawn(Pawn).ExperienceMath(Amount);
}
    
defaultproperties
{   
    bCombat = false;
    //CameraClass=class'BladeOD.BladeCamera'
    InputClass=class'BladePlayerInput'
    PlayerInvClass=class'BladePlayerInventory'
}