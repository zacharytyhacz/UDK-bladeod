class BladeButton extends Actor 
	ClassGroup(BladeButtons) placeable;
	
var(Button) int MaxPresses;
var			int presses;
	
function Pressed(BladePlayerController pc)
{
	if(PC !=  None)
	{
		if(MaxPresses == 0) 
		{
			TriggerEventClass(class'SeqEvent_Unlock',PC,0);
		}
		
		if(presses != MaxPresses)
		{
			TriggerEventClass(class'SeqEvent_Unlock',PC,0);
			presses++;
		}
	}		
}
	
defaultproperties
{
	MaxPresses = 1;
	
	SupportedEvents.Empty
    SupportedEvents(0)=class'SeqEvent_Unlock'
	
	Begin Object class=SkeletalMeshComponent Name=ButtonMesh
       SkeletalMesh=SkeletalMesh'BladeEnvironment.Buttons.blade_button1_mesh'
	   AnimSets(0)=AnimSet'BladeEnvironment.Buttons.blade_button1_mesh_Anims'
    End Object
    Components.Add(ButtonMesh)
}