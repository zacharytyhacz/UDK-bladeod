//////////////////////////////////////////////////
// This is the sound info class for entities    //
// When an entity does any type of swing, any   //
// type of taunt, or any type of death,         //
// the sound will come from here                //
//////////////////////////////////////////////////
class BladeSoundInfo extends Object abstract;


struct FootstepSoundInfo
{
    var name MaterialType;
    var SoundCue Sound;
};

// Death 
var SoundCue RegDeathSound;

var SoundCue ArrowDeathSound;
var SoundCue BluntDeathSound;
var SoundCue SwordDeathSound;
// elements
var SoundCue FireDeathSound;
var SoundCue IceDeathSound;
var SoundCue PosionDeathSound;
var SoundCue VampDeathSound;

// Swinging HEE YA
var SoundCue LightSwingSound;
var SoundCue FastSwingSound;
var SoundCue HeavySwingSound;

// Hits
var SoundCue HitSwordSound;         // SoundCue will have randomizor of sounds in it
var SoundCue HitBluntSound;
var SoundCue ArrowHit;

// Movement
var SoundCue RunStepSound;          
var SoundCue FallSound;
var SoundCue WalkStepSound;     // Copy of RunStepSound, but will be twisted with pitch and length
var SoundCue DefaultLandingSound;
var SoundCue DefaultFootstepSound;

var array<FootstepSoundInfo> FootstepSounds;
var array<FootstepSoundInfo> JumpingSounds;
var array<FootstepSoundInfo> LandingSounds;

// Communication ( mostly for enemies )
var SoundCue TauntSound;
var SoundCue LaughSound;
var SoundCue StartleSound;

// Other
var SoundCue BreatheSound;
var SoundCue FallingScreamSound;    // when the pawn has fallen off a high edge off the map, they scream

////////////////////////////////////////////////////////// Communication
static function PlayTauntSound(Pawn P)
{
    P.PlaySound(Default.TauntSound,false,false);
}

static function PlayLaughSound(Pawn P)
{
    P.PlaySound(Default.LaughSound,false,false);
}

static function PlayStartleSound(Pawn P)
{
    P.PlaySound(Default.StartleSound,false,false);
}

///////////////////////////////////////////////////////// Death
static function PlayArrowDeathSound(Pawn P)
{
    P.PlaySound(Default.ArrowDeathSound,false,false);
}

static function PlayBluntDeathSound(Pawn P)
{
    P.PlaySound(Default.BluntDeathSound,false,false);
}

static function PlaySwordDeathSound(Pawn P)
{
    P.PlaySound(Default.SwordDeathSound,false,false);
}

static function PlayFireDeathSound(Pawn P)
{
    P.PlaySound(Default.FireDeathSound,false,false);
}

static function PlayDeathSound(Pawn P)
{
    P.PlaySound(Default.RegDeathSound,false,false);
}

static function PlayPoisonDeathSound(Pawn P)
{
    P.PlaySound(Default.PosionDeathSound,false,false);
}

static function PlayIceDeathSound(Pawn P)
{
    P.PlaySound(Default.IceDeathSound,false,false);
}

static function PlayVampireDeathSound(Pawn P)
{
    P.PlaySound(Default.VampDeathSound,false,false);
}
///////////////////////////////////////////////////////////// Swings
static function PlayLightSwingSound(Pawn P)
{
    P.PlaySound(Default.LightSwingSound,false,false);
}

static function PlayFastSwingSound(Pawn P)
{
    P.PlaySound(Default.FastSwingSound,false,false);
}

static function PlayHeavySwingSound(Pawn P)
{
    P.PlaySound(Default.HeavySwingSound,false,false);
}
////////////////////////////////////////////////////////////// Hits
static function PlaySwordHitSound(Pawn P)
{
    P.PlaySound(Default.HitSwordSound,false,false);
}

static function PlayBluntHitSound(Pawn P)
{
    P.PlaySound(Default.HitBluntSound,false,false);
}

static function PlayArrowHitSound(Pawn P)
{
    P.PlaySound(Default.ArrowHit,false,false);
}