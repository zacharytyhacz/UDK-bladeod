class BladeChangeLevel extends Trigger placeable;
// Reference this in the worldinfo gametype!!!! NextLevel To change to 
var(ChangeLevel) string MapName;

event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
    Super.Touch(Other,OtherComp,HitLocation,HitNormal);
    
    ChangeMap();    
}

exec simulated function ChangeMap()
{
    ConsoleCommand("open "$ MapName);
}

defaultproperties
{
   MapName="UDKFrontEndMap"
   
   Components.Remove(Sprite) 
   
   Begin Object Class=SpriteComponent Name=Icon
    Sprite=Texture2D'BladeIcons.Icons.mapchangearrow'
    HiddenGame=false
    AlwaysLoadOnClient=False
    AlwaysLoadOnServer=False
   End Object
   Components.Add(Icon)
}