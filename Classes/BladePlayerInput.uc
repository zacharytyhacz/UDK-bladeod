class BladePlayerInput extends PlayerInput 
    within BladePlayerController config(BladePlayerInput);
    

var bool wPressed; // is W being pressed? 
var bool aPressed;
var bool sPressed;
var bool dPressed;

var bool bIsClicking;


function Tick(float deltatime)
{
    Super.Tick(deltatime);
    //`log(" w = "$ wPressed $ " a = " $ aPressed $ " s = " $ sPressed $ " d = " $ dPressed);
}   
/*
function ChangewPressed(bool IsPressed)
{
    wPressed = IsPressed;
}

function ChangeaPressed(bool IsPressed)
{
    aPressed = IsPressed;
}

function ChangesPressed(bool IsPressed)
{
    sPressed = IsPressed;
}

function ChangedPressed(bool IsPressed)
{
    dPressed = IsPressed;
}

function bClicking(bool IsClicking)
{
    bIsClicking = IsClicking;
}

// returns
simulated function bool IsWPressed()
{   
    return wpressed;
}

simulated function bool IsAPressed()
{   
    return aPressed;
}

simulated function bool IsSPressed()
{   
    return sPressed;
}

simulated function bool IsDPressed()
{   
    return dPressed;
}
   */
defaultproperties
{
}