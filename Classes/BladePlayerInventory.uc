// Player Inventory: The class that controls items,weapons and shields.
// Adds and removes items, weapons and shields.
class BladePlayerInventory extends Actor;

/*      Weapons         */
var array<class<BladeWeapon> > WeaponSlots;

var() int MaxWeaponSlots;

/*          Items           */
var array<class<BladeItem> > ItemSlots;

// Max Amounts
var         int     Max100;
var         int     Max500;
var         int     Max1000;
var         int     Max1500;
var         int     Max2000;
var         int     MaxFull;
// Current Amounts
var         int     Cur100;
var         int     Cur500;
var         int     Cur1000;
var         int     Cur1500;
var         int     Cur2000;
var         int     CurFull;

/*      Shields         */
var array<class<BladeShield> > ShieldSlots;

var() int MaxShieldSlots;

var BladePawn Master;

function CreateOwner(BladePawn P) // create the owner, like possess
{
    if(P != None && Master == None)
    {
        Master = P;
    }
}

function Tick(float deltatime)
{   
	local int i;
    if(WeaponSlots.Length < MaxWeaponSlots)
    {
        Master.ChangeWeaponRoom(true);
    }
    
    if(WeaponSlots.Length == MaxWeaponSlots)
    {
        Master.ChangeWeaponRoom(false);
    }
    
    if(ShieldSlots.Length < MaxShieldSlots)
    {
        Master.ChangeShieldRoom(true);
    }
    
    if(ShieldSlots.Length == MaxShieldSlots)
    {
        Master.ChangeShieldRoom(false);
    }       
	
	for(i = 0;i<WeaponSlots.Length;i++)
	{
		//`log("========================= I have a "$ i @ WeaponSlots[i]);
	}
    Super.Tick(DeltaTime);
}
// Weapons
function NewWeapon(class<BladeWeapon> Weapon) // insert weapon from bladeweapon class
{
    if(WeaponSlots.Length < MaxWeaponSlots) // if there are open slots...
    {       
        if(WeaponSlots.Length == 4) // if adding a weapon to the last slot
        {
            WeaponSlots.AddItem(Weapon);
            Master.ChangeWeaponRoom(false); // you'll have no room left
            Master.NewWeapon(Weapon);
        }
        else // if you have 2 or more open slots open
        {
            WeaponSlots.AddItem(Weapon);
            Master.ChangeWeaponRoom(true); // Yes,you have room!
            Master.NewWeapon(Weapon);
        }        
    }
    else if((WeaponSlots.Length == MaxWeaponSlots) || (WeaponSlots.Length > MaxWeaponSlots)) // if there are no open slots...
    {
        Master.ChangeWeaponRoom(false); // No, you don't have room!
    }    
}

function DropWeapon(class<BladeWeapon> Weapon)
{
    if((WeaponSlots.Length == MaxWeaponSlots) || (WeaponSlots.Length > 2) || (WeaponSlots.Length == 2))
    {
        WeaponSlots.RemoveItem(Weapon);
        Master.ChangeWeaponRoom(true);
        Master.NoWeapon();     
    }
    else if(WeaponSlots.Length == 1) // if you give away your last weapon, you have to use YOUR FISTS!!
    {
        WeaponSlots.RemoveItem(Weapon);
        Master.ChangeWeaponRoom(true);
        Master.NoWeapon();
    }    
}

function NextWeapon(int WOffset)
{
	local class<BladeWeapon> PawnWeapon;
	local int i, index;
	
	PawnWeapon = Master.MyWeapon;
	`log("my current weapon is "$ PawnWeapon);
	if(PawnWeapon == None)
	{
		`log("no current weapon found");
		return; // you have no weapons
	}
	
	if(WeaponSlots.Length == 0)
	{
		`log("no weapons found in the weapon slots array");
		return;
	}
	
	for (i = 0; i < WeaponSlots.Length; i++)
	{
		if (WeaponSlots[i] == PawnWeapon) // if the weapon in the lots if the currentweap
		{
			`log("found "$ PawnWeapon $" in weapon slot" $ i $" - "$ WeaponSlots[i]);
			Index = i;
			break;
		}
	}
	
	Index += WOffset;
	`log("index is"$ index);
	if(Index > WeaponSlots.Length)
	{
		`log("index is greater than the length, setting it to 0");
		Index = 0;
	}	
	
	if(Index >= 0)
	{
		`log("changing weapon to "$ WeaponSlots[Index]);
		Master.ChangeWeapon(WeaponSlots[Index]);
	}
}

//Shields
function NewShield(class<BladeShield> Shield) // insert weaponname from bladeweapon class
{
    if(ShieldSlots.Length < MaxShieldSlots) // if there are open slots...
    {
        ShieldSlots.AddItem(Shield);
        Master.ChangeShieldRoom(true); // Yes,you have room!
        Master.NewShield(shield);
    }
    else if((ShieldSlots.Length == MaxShieldSlots) || (ShieldSlots.Length > MaxShieldSlots)) // if there are no open slots...
    {
        Master.ChangeShieldRoom(false); // No, you don't have room!
        Master.NewShield(shield);
    }
}

function DropShield(class<BladeShield> Shield)
{
    if((ShieldSlots.Length == MaxShieldSlots) || (ShieldSlots.Length > 2) || (ShieldSlots.Length == 2))
    {
        ShieldSlots.RemoveItem(Shield);
        Master.ChangeShieldRoom(true);
        Master.NoShield();
    }
    else if(ShieldSlots.Length == 1) // if you give away your last weapon, you have to use YOUR FISTS!!
    {
        ShieldSlots.RemoveItem(Shield);
        Master.ChangeShieldRoom(true);
        Master.NoShield();
    }
}

// Items
function PickupItem(class<BladeItem> Item) // insert Item from BladeItem class
{
    if(Item != None)
    {
        ItemSlots.AddItem(Item);
    }
    
    if(Item.IsA('BladePotion_100'))
    {
        if(Cur100 < Max100)
        {
            Cur100++;
        }
        if(Cur100 == Max100)
        {
            `log("I do not have enough room for "$ Item);
        }
    }
    
    if(Item.IsA('BladePotion_500'))
    {
        if(Cur500 < Max500)
        {
            Cur500++;
        }
        if(Cur500 == Max500)
        {
            `log("I do not have enough room for "$ Item);
        }
    }
    
    if(Item.IsA('BladePotion_1000'))
    {
        if(Cur1000 < Max1000)
        {
            Cur1000++;
        }
        if(Cur1000 == Max1000)
        {
            `log("I do not have enough room for "$ Item);
        }
    }
    
    if(Item.IsA('BladePotion_1500'))
    {
        if(Cur1500 < Max1500)
        {
            Cur1500++;
        }
        if(Cur1500 == Max1500)
        {
            `log("I do not have enough room for "$ Item);
        }
    }
    
    if(Item.IsA('BladePotion_2000'))
    {
        if(Cur2000 < Max2000)
        {
            Cur2000++;
        }
        if(Cur2000 == Max2000)
        {
            `log("I do not have enough room for "$ Item);
        }
    }
    
    if(Item.IsA('BladePotion_Full'))
    {
        if(CurFull < MaxFull)
        {
            CurFull++;
        }
        if(CurFull == MaxFull)
        {
            `log("I do not have enough room for "$ Item);
        }
    }                        
}

function DropItem(class<BladeItem> Item)
{
    if(Item.IsA('BladeKey'))
    {
        ItemSlots.RemoveItem(Item);
    }
    
    if(Item.IsA('BladePotion_100'))
    {
        ItemSlots.RemoveItem(Item);
        Cur100--;
    }
    
    if(Item.IsA('BladePotion_500'))
    {
        ItemSlots.RemoveItem(Item);
        Cur500--;

    }
    
    if(Item.IsA('BladePotion_1000'))
    {
        ItemSlots.RemoveItem(Item);
        Cur1000--;

    }
    
    if(Item.IsA('BladePotion_1500'))
    {
        ItemSlots.RemoveItem(Item);
        Cur1500--;
    }
    
    if(Item.IsA('BladePotion_2000'))
    {
        ItemSlots.RemoveItem(Item);
        Cur2000--;

    }
    
    if(Item.IsA('BladePotion_Full'))
    {
        ItemSlots.RemoveItem(Item);
        CurFull--;
    }                        
}

/** 
*   these functions take in a class to find in a specific array, item ,weapon, etc
*   returns true if that class is present
*   returns false if that class is not present
**/
function bool FindItem(class<actor> A)
{
    if(A != None)
    {
        if(ItemSlots.Find(A) != INDEX_NONE)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}

function bool FindWeapon(class<bladeweapon> W)
{
    if(W != None)
    {
        if(WeaponSlots.Find(W) != INDEX_NONE)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}

function bool FindShield(class<bladeshield> S)
{
    if(S != None)
    {
        if(ShieldSlots.Find(S) != INDEX_NONE)
        {
            return true;
        }
        else    
        {
            return false;
        }
    }
}

defaultproperties
{
    MaxShieldSlots=5
    
    MaxWeaponSlots=5
    
    // customizable maxes for items 
    Max100=4
    Max500=4
    Max1000=2
    Max1500=2
    Max2000=1
    MaxFull=1   
}