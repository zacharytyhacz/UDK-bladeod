// This class contains information about the players and/or other pawns mesh statistics
class BladeCharacterInformation extends Actor abstract;

// the numbers are the level of armor, 0 is default without armor and 3 is most/highest armor
var array<AnimSet>              BladeAnimSet0;
var PhysicsAsset                BladePhysicsAsset0;
var SkeletalMesh                BladeSkeletalMesh0;
var AnimTree                    BladeAnimTree0;

var array<AnimSet>              BladeAnimSet1;
var PhysicsAsset                BladePhysicsAsset1;
var SkeletalMesh                BladeSkeletalMesh1;
var AnimTree                    BladeAnimTree1;

var array<AnimSet>              BladeAnimSet2;
var PhysicsAsset                BladePhysicsAsset2;
var SkeletalMesh                BladeSkeletalMesh2;
var AnimTree                    BladeAnimTree2;

var array<AnimSet>              BladeAnimSet3;
var PhysicsAsset                BladePhysicsAsset3;
var SkeletalMesh                BladeSkeletalMesh3;
var AnimTree                    BladeAnimTree3;


// The sound info for this character information
var() class<BladeSoundInfo>		BladeSoundInfo;
// do not need an actor ref, static function are present in this class ^ ^ ^ 
final function Init()
{
	if(BladeSoundInfo == None)
	{
		BladeSoundInfo = class'BladeSoundInfo';
		return;
	}
}

defaultproperties
{
	BladeSoundInfo=class'BladeSoundInfo'
}