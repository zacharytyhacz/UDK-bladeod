class BladeMainMenu extends GFxMoviePlayer;

var GFxClikwidget startbutton, loadbutton, savebutton, optionsbutton, exitbutton, label1;

var() string firstmapname;

function bool Start(optional bool StartPaused = false)
{
    Super.Start();
    Advance(0);
    
    return true;
}

event bool widgetinitialized(name widgetname, name widgetpath, GFxObject widget)
{
    switch(widgetname)
    {
        case('startbutton'):
            startbutton = GFxClikwidget(widget);
            startButton.AddEventListener('CLIK_press', OnStartPress);
            break;
        case('loadbutton'):
            loadbutton = GFxClikwidget(widget);
            loadbutton.AddEventListener('CLIK_press', OnLoadPress);
            break;
        case('savebutton'):
            savebutton = GFxClikwidget(widget);
            savebutton.AddEventListener('CLIK_press', OnSavePress);
            break;
        case('optionsbutton'):
            optionsbutton = GFxClikwidget(widget);
            optionsbutton.AddEventListener('CLIK_press', OnOptionsPress);
            break;
        case('exitbutton'):
            exitbutton = GFxClikwidget(widget);
            exitbutton.AddEventListener('CLIK_press', OnExitPress);
            break;
        case('versionname'):
            Label1 = GFxClikwidget(widget);
            Label1.SetText("Alpha Version 1.0 - Aug. 2015");
            break;
        default:
            break;
    }
    return true;
}

function OnStartPress(GFxClikWidget.EventData ED)
{
    ConsoleCommand("open "$ firstmapname);
}

function OnExitPress(GFxClikWidget.EventData ED)
{
    ConsoleCommand("exit");
}

function OnLoadPress(GFxClikWidget.EventData ED)
{
    //ConsoleCommand("open "$ firstmapname);
}

function OnSavePress(GFxClikWidget.EventData ED)
{
    // ConsoleCommand("open "$ firstmapname);
}    

function OnOptionsPress(GFxClikWidget.EventData ED)
{
    //ConsoleCommand("open "$ firstmapname);
}
    
defaultproperties
{
    firstmapname="bladetesting"
    widgetBindings.Add((widgetname="startbutton", widgetclass=class'GFxClikWidget'))
    widgetBindings.Add((widgetname="loadbutton", widgetclass=class'GFxClikWidget'))
    widgetBindings.Add((widgetname="savebutton", widgetclass=class'GFxClikWidget'))
    widgetBindings.Add((widgetname="optionsbutton", widgetclass=class'GFxClikWidget'))
    widgetBindings.Add((widgetname="exitbutton", widgetclass=class'GFxClikWidget'))
    widgetBindings.Add((widgetname="versionname", widgetclass=class'GFxClikWidget'))
}