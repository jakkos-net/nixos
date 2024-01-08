{lib, ...} :
let
  # for each item in this list, create a desktop entry
  # e.g. this allows me start a firefox private window from my app launcher
  entries = [
    {name = "ff"; exec = "firefox --new-window";}
    {name = "fp"; exec = "firefox --private-window";}
    {name = "ym"; exec = "firefox --new-window music.youtube.com";}
    {name = "wa"; exec = "firefox --new-window web.whatsapp.com";}
    {name = "gm"; exec = "firefox --new-window gmail.com";}
    {name = "ta"; exec = "firefox --new-window https://calendar.google.com/calendar/u/0/r/tasks";}
  ];
in
{
  xdg.desktopEntries = lib.attrsets.mergeAttrsList (
      map (entry: {"${entry.name}" = entry;}) entries  
  );
}
