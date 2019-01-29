class BladeDamageType extends DamageType
abstract;

var bool            bPosion;            // will this damage cause posion damage
var bool            bFire;
var bool            bIce;
var bool            bVamp;

var bool            bHasEffect;         // will this damage create an effect around the hitactor? 

var float           EffectTime;

defaultproperties
{
    EffectTime=0.5
    bPosion=false
    bFire=false
    bIce=false
    bVamp=false
    bHasEffect=false
}    
