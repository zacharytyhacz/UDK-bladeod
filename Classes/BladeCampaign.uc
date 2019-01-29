class BladeCampaign extends Actor;

// The first map of this campaign
var string StartMap;

// Name of this campaign
var string CampaignName;

// Author of this Campaign
var string Author;

// Picture of Campaign
var Texture2D SnapShot;

static function string GetName()
{
    return default.CampaignName;
}

static function string GetStartMap()
{
    return default.StartMap;
}

static function string GetAuthor()
{
    return default.Author;
}

static function Texture2D GetPicture()
{
    return default.SnapShot;
}

defaultproperties
{
   StartMap="bladetesting"
   CampaignName="Blade"
   Author="Ya Boy"
   SnapShot=Texture2D'SponzaNew_Resources.T_Flower_01_D'
}