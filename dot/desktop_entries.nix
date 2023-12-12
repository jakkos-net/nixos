{lib, ...} :
let
  # for each item in this list, create a desktop entry
  # e.g. this allows me start a firefox private window from my app launcher
  entries = [
    {name = "fp"; exec = "firefox --private-window";}
    {name = "ym"; exec = "firefox --new-window music.youtube.com";}
    {name = "wa"; exec = "firefox --new-window web.whatsapp.com";}
    {name = "gm"; exec = "firefox --new-window gmail.com";}
  ];
in
{
  xdg.desktopEntries = lib.attrsets.mergeAttrsList (
      map (entry: {"${entry.name}" = entry;}) entries  
  );
}
