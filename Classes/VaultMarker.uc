class VaultMarker extends Actor placeable;

//StaticMesh'BladeEnvironment.Mesh.blade_vaultmarker'



defaultproperties
{
    Begin Object class=StaticMeshComponent Name=VaultMesh
        StaticMesh=StaticMesh'BladeEnvironment.Mesh.blade_vaultmarker'
        HiddenGame=true
        CollideActors=false // even though the mesh does not have collision
    End Object
    Components.Add(VaultMesh)
    
    Begin Object class=SpriteComponent Name=Sprite
        Sprite=Texture2D'EditorResources.S_Actor'
        HiddenGame=true
    End Object
    Components.Add(Sprite)
    
    bCollideActors=false
    bBlockActors=false
}