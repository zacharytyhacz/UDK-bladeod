class BladeGameType extends SimpleGame;
   
auto state Setup
{
    function InitPawns()
    {
        local BladeMapInfo MapInfo;
        
        local BladeAI AIcontrol;
        local BladeAIPawn AIPawn;
        local BladeEnemySpawn BladeEnemySpawn;        
        local class<BladeAIPawn> PawnClass;
        local BladePawn BP;
        
        //Super.PostBeginPlay();        
        MapInfo = BladeMapInfo(WorldInfo.GetMapInfo());       
        // if the lveel is the first level of the game/story, everything must be their default properties
        if(MapInfo != None)
        {
            foreach WorldInfo.AllPawns(class'BladePawn',BP)
            {                  
                //BP.InitializeInventories();  changed this so that this is initiazted in the possess() function in the PC                              
                if(MapInfo.FirstLevel)
                {                
                    BP.Level     = BP.default.Level;
                    BP.HealthMax = BP.default.HealthMax;
                    BP.MaxEnergy = BP.default.MaxEnergy;
                    BP.Power     = Bp.default.power;
                    BP.defense   = BP.default.defense;
                    BP.currentexperience = 0.0;
                    BP.maxexperience = BP.default.maxexperience;            
                    BP.SetArmorLevel(0);
                    
                    BP.NoShield();
                    BP.NoWeapon();
                    
                    `log("All player pawn settings have been set to first level stats");
                }               
                else
                {     
                    //reload variables from the load/save object and apply them here       
                } 
				BP.Health = BP.HealthMax; 				
            }
        }
        
        foreach WorldInfo.AllNavigationPoints(class'BladeEnemySpawn', BladeEnemySpawn)
        {
            if(!BladeEnemySpawn.bInUse)
            {            
                if(BladeEnemySpawn.bSpawnOnStart && BladeEnemySpawn.BWeapon != None 
                    && BladeEnemySpawn.PawnToSpawn != None)
                {                               
                    AIcontrol=Spawn(class'BladeAI');
                    //AIcontrol.Initialize(BladeEnemySpawn);
                    PawnClass = BladeEnemySpawn.PawnToSpawn;
                    
                    AIPawn = Spawn(PawnClass,,,BladeEnemySpawn.Location,BladeEnemySpawn.Rotation);
                    AIcontrol.Possess(AIPawn, false);
                    AIcontrol.MySpawnPoint = BladeEnemySpawn;
                    AIPawn.DroppedItemClass = BladeEnemySpawn.DroppableItem;
                    AIPawn.SetStats(BladeEnemySpawn.Level, BladeEnemySpawn.ExpToGive, BladeEnemySpawn.Aggression);
                    if(BladeEnemySpawn.Shield != None)
                    {
                        // give inventory function is easy way to give weapons and shields (opt)
                        AIPawn.GiveInventory(BladeEnemySpawn.BWeapon, BladeEnemySpawn.Shield);
                    }
                    else
                    {
                        AIPawn.GiveInventory(BladeEnemySpawn.BWeapon);
                    }
                    AIPawn.DroppedItemClass = BladeEnemySpawn.DroppableItem;
                    if(BladeEnemySpawn.WalkNode[0] != None)
                    {
                        AIPawn.SetWalkingNode(BladeEnemySpawn.WalkNode[0]);
                    }
                    
                    BladeEnemySpawn.bInUse = true;
                
                    `log("All enemy spawn points are initialized");
                }                    
                if(!BladeEnemySpawn.bSpawnOnStart)
                { 
                    // have to wait for kismet sequence to spawn
                }
            }                
            else
            {
                
            }                    
        }                                                                 
    }
Begin:
    InitPawns();
}
    

defaultproperties
{
    PlayerControllerClass=class'BladePlayerController'
    DefaultPawnClass=class'BladePawn'
    HUDType=class'BladeHUD'
}    