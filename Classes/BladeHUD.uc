class BladeHUD extends HUD dependson(BladePlayerController);

var BladePlayerController BPC;

var BladePawn             BP;

var string                ShownText;



var string 			NearText; // text shown on objects 
var vector			NearTextLoc;
var vector 			PendingNearLoc;

// Target Lock On
var CanvasIcon             TargetIcon;
var int 				   TargetLevel;
var int 				   TargetHealth;

// weapon switching 
var bool bSwitchingWeapons;
var CanvasIcon SelectedWeapon;
var array<class<BladeWeapon> > WeaponList; // array of weapon icon textures
var transient int SelectedWeaponSlot;


var float SelectedX;
var float SelectedY;

function NowSwitching(bool bIsSwitching)
{
	bSwitchingWeapons = bIsSwitching; // toggle function 
	ClearTimer('NotSwitchingWeapons');
	SetTimer(3.0f,false,'NotSwitchingWeapons');
	
}

function NotSwitchingWeapons()
{
	bSwitchingWeapons = false;
}

function SelectedWeaponIs(class<BladeWeapon> InWeapon, int arraynum)
{
	SelectedWeapon.Texture = WeaponList[arraynum].static.GetWeaponIcon();
	SelectedWeaponSlot = arraynum;
}

function SetWeaponList(class<BladeWeapon> InWeapon)
{	
	WeaponList.AddItem(InWeapon);
}

function NextSelectedWeapon()
{
	SelectedWeapon.Texture = WeaponList[SelectedWeaponSlot++].static.GetWeaponIcon();	
	// switch weap on player
}

function ResetWeaponList()
{
	local int i;
	
	for(i = 0; i < WeaponList.Length; i++)
	{
		WeaponList.RemoveItem(WeaponList[i]); // safe removal of all items in the list
		`log("HUD WeaponList has been reset");
	}
}	

function PostBeginPlay()
{
    Super.PostBeginPlay();
    
    BPC = BladePlayerController(Owner);    
    
    BP = BladePawn(BPC.Pawn);
}

function DrawHUD()
{
    local int iHealthRed,iHealthGreen;   
    super.DrawHUD(); 
   
    if(BP.bIsPoisoned)
    {
       iHealthRed = 0;
       iHealthGreen = 170;       
    }   
    else if(!BP.bIsPoisoned)
    {
       iHealthRed = 255;
       iHealthGreen = 0;
    }
   
    Canvas.Font = class'Engine'.static.GetLargeFont();
    Canvas.SetPos(25,10,0);
    Canvas.SetDrawColor(iHealthRed,iHealthGreen,0);
    Canvas.DrawText("Health:" $ BP.Health $"/" $ BP.HealthMax);
	
    Canvas.SetPos(25,50,0);
    Canvas.SetDrawColor(0,0,255);
    Canvas.DrawText("Level:" $ BP.Level);
   
    Canvas.SetPos(25,90,0);
    Canvas.SetDrawColor(100,0,100);
    Canvas.DrawText("Defense:" $ BP.Defense);
   
    Canvas.SetPos(25,130,0);
    Canvas.SetDrawColor(100,0,100);
    Canvas.DrawText("Power:" $ BP.Power);
   
    Canvas.SetPos(25,170,0);
    Canvas.SetDrawColor(0,255,0);
    Canvas.DrawText("Experience:" $ BP.CurrentExperience $" / "$ BP.MaxExperience);
	
	Canvas.SetPos(40,300,0);
	Canvas.SetDrawColor(255,255,255);
	Canvas.DrawText(showntext);
	
	//Canvas.SetPos(600,10,0);
	//Canvas.DrawBox(48,48);
	
	if(targeticon.texture != None)
	{
		//`log("drawing target icon ");
		//Canvas.SetPos(600,10,0);
		Canvas.DrawIcon(targeticon,600,10,0.125);
		
		if(TargetLevel > 0)
		{
			Canvas.Font = class'Engine'.static.GetTinyFont();
			
			Canvas.SetPos(660,5,0);
			Canvas.SetDrawColor(0,0,255);
			Canvas.DrawText(TargetLevel);
			
			Canvas.Font = class'Engine'.static.GetTinyFont();
			
			Canvas.SetPos(600,80,0);
			Canvas.SetDrawColor(255,0,0);
			Canvas.DrawText(TargetHealth);			
		}
	}
	
	if(NearTextLoc != vect(0,0,0))
	{
		`log("projecting actor cords");
		NearTextLoc = Canvas.Project(PendingNearLoc);
		Canvas.SetPos(NearTextLoc.x,NearTextLoc.y,0);
		Canvas.SetDrawColor(0,0,0);
		Canvas.DrawText(NearText);
	}	
	
	if(bSwitchingWeapons)
	{
		Canvas.DrawIcon(SelectedWeapon, SelectedX, SelectedY, 1); // draw selected weapon first in selected spot
	}
}

simulated function SetShownText(string text)
{
    ShownText = text;
    SetTimer(3.0,false);
}

function SetTargetIcon(texture2d texture, int level, int health)
{
	//`log("changing the target icon to "$ texture );
	//`LOG("################################################### "$ targeticon.texture @ targeticon.u @ targeticon.v);
    TargetIcon.texture = texture;  
	TargetLevel = level;
	
	if(TargetHealth != health)
	{	
		TargetHealth = health;
	}
}

function RemoveTargetIcon()
{
	targeticon.texture = None;
}

simulated function Get2DLocationOf(vector loc,string Text)
{
	PendingNearLoc = location;
	NearText = Text;
}

event Timer()
{   
    showntext = "";
}

defaultproperties
{
	targeticon=(Texture=None,U=0,V=0,UL=512,VL=512)
	SelectedWeapon=(Texture=None,U=0,V=0,UL=256,VL=128)
	SelectedX=800.0f
	SelectedY=800.0f
}