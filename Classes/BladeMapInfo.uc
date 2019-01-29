class BladeMapInfo extends MapInfo;


// Is this the first map of the campaign?
var(Map) bool FirstLevel;

// the campaign of this map
var(Map) class<BladeCampaign> Ladder;

/*
function string GetCampaignName()
{
    return Ladder.static.GetName();
}

function string GetStartMap() 
{
    return Ladder.static.GetStartMap();
}
*/
defaultproperties
{
}