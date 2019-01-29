class BladeAI extends AIController;

/* Combat Flags */
var float               LastBlockTime;        // Last time used shield to block
var bool                bBlockedAttack;        // whether or not i blocked an attack
var float               LLastSwingTime;       // Last time I lightly swung
var float               MLastSwingTime;       // Last time I mediumly swung
var float               HLastSwingTime;       // last time I heavily swung 
var float               LastSeenSwing;        // last time i saw a swing from the player
var float               LastGotHitTime;       // Last time I got hit 
var float               LastDodgeTime;        // Last time I dodged 
var Pawn                HitBy;                // the pawn I got hit by 
var BladeAIPawn         MyFriend;       // the nearby pawn that's helping me 
var Pawn 				TempEnemy;			  // temporary enemy, ( goes back to playe after) for
                                              // hits by friend or ally
					
// Walking 
var BladeWalkNode       WalkNode, CurrentNode;
/* player related */
var float              PlayerDistance;
var vector              LastSeenLoc;
var float               LastSeen;
var float               LastSeenDodge;
var bool                bHasSeenPlayer;      
var bool                bSeeSwing;             // advanced - do i see that the player is swining 
var bool                bPlayerBlocking;
var bool                bAtPlayer;             // am i at the player, can i start doing combat swinging and dodging and such?

/* Advanced Combat Flags */
var bool                bDoubleTeam;           // Am I double teaming the player?
var bool                bArcher;               // Am I an archer?
var bool                bUseRanged;            // should i use my ranged attack?
var bool                bHitByFriend;          // Was I hit by a friend?
var bool                bTurnOnFriend;
var bool                bHasItem;              // checks in the pawn class for the item, then decides when to use item
var bool                bPatrolling;
var bool                bInSafeArea;           // volume that the pawn can be in, like a safe spot that the pawn attempts to stay in to be safe(r) 
var bool                bInCombat;

/* Spawning */
var bool bSpecialSpawn;         // do I spawn in a special way, like out of ground, middair, etc
var BladeEnemySpawn MySpawnPoint;

/************************************************************/
/*        Enumeration of attitude toward a pawn             */
/*       similar to UT99's attitude systems, it works       */
/*       on what to do when this AI is hit by a pawn        */
/*       and whether or not to attack, even out or ignores  */
/************************************************************/
 
var enum AttitudeTowardPawn
{
    ATT_None,
    ATT_Ignore,         // Just get hit by the pawn
    ATT_Attack,         // Get in full combat mode and attack the pawn ( ONLY TO PLAYER ) mostly
    ATT_Defend,         // When hit by friend, attempt to keep shield up and not get hit, but dont fight him
    ATT_EvenOut,        // When hit by friend, attempt to deal the same amount of damage back to the friend
} AttitudeToPawn;
    
function Possess(Pawn aPawn, bool bVehicleTransition)
{
    aPawn.PossessedBy(Self, False);
    
    Super.Possess(aPawn, bVehicleTransition); 
    Pawn.SetMovementPhysics();
}

function Restart(bool bVehicleTransition)
{ 
    Super.Restart(bVehicleTransition);   
}

function tick(float deltatime)
{
    Super.Tick(deltatime);
    //`log("my pawn is "$ Pawn);
	if(Enemy != None)
	{
		PlayerDistance = Vsize(Pawn.Location - Enemy.Location);
	}
}
 
auto state Idle
{   
    function SeePlayer(Pawn Seenpawn)
    {
        if(Enemy==None)
        {
            if(Seenpawn.Controller.IsA('BladePlayerController'))
            {
                //`log("I see "$ SeenPawn $" that is at "$SeenPawn.Location);
                // because the pawn is controlled by the player controller, its the player pawn
                Enemy=SeenPawn;
                    
                if(PlayerDistance <= 1500)
                {    
                    `log(self$"I see the player, going to persuit");
                    GoToState('Persuit');
                }   
                else
                {
                    `log(self$"I see the player, but the player is too far away!");
                    Enemy = None;
                    return;
                }
            }
        }
    }
    
    function WalkAround()
    {
		if(Enemy == None)
		{
			if(CurrentNode == None)
			{
				if(BladeAIPawn(Pawn).GetWalkNode() != None)
				{
					CurrentNode = BladeAIPawn(Pawn).GetWalkNode();
					Pawn.GroundSpeed = 60.0f;
					`log("i want to walk to "$ CurrentNode);
				}
			}
		}
    }
	
	function InitFriends()
	{
	}
Begin:
    `log(self$" I am idle...");   
    WalkAround();
	InitFriends();
	MoveToward(CurrentNode,CurrentNode,,false);
	//sleep(3.0);
	Goto('Begin');
}
   
state Persuit
{
    function EnemyNotVisible()
    {
        Super.EnemyNotVisible();
        if(Enemy != None)
        {
            `log(self$"I lost the player");
            GoToState('Idle');
            Enemy = None;
        }
    }
    
    function EngageCombat()
    {
        `log(self$"I engaged combat, check to see if my enemy is still there");
        bPatrolling = false;
        if(Enemy == None)
        {
            `log(self$" I lost my enemy");
            GoToState('Idle');
        }
        if(Enemy != None)
        {
            `log(self$"Enemy Still there, Attemping to move toward enemy");
            MoveTarget = Enemy;
			if(PlayerDistance >= 400.0f)
			{
				Pawn.GroundSpeed = 200.0f;  // run to get to palyer quicker
			}
			else if(PlayerDistance <=399.9f)
			{
				Pawn.GroundSpeed = 80.0f;  // once close, slow it down
			}
            //Pawn.GroundSpeed = 200.0;  
        }
        
    }
    
    function BeginState(name PreviousState)
    {
    }
    
    function EndState(name NextState)
    {
    }
        
        
        
Begin:
	Pawn.GroundSpeed = Pawn.default.GroundSpeed;
    `log(self$" Persuiting started, engaging combat");
    EngageCombat();
    MoveToward(MoveTarget,MoveTarget,,false);
    Goto('Begin');
}

defaultproperties
{	
	
}