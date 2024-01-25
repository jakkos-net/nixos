{lib, ...} :
let
  browser = tabs : "firefox --new-window " + (builtins.concatStringsSep " "(builtins.map (tab : "--new-tab -url ${tab}") tabs));
  # for each item in this list, create a desktop entry
  # e.g. this allows me start a firefox private window from my app launcher
  entries = [
    {name = "ff"; exec = browser [];}
    {name = "fp"; exec = "firefox --private-window";}
    {name = "wa"; exec = browser [
      "https://calendar.google.com/calendar/u/0/r/tasks"
      "https://calendar.google.com/calendar/u/0/r"
    ];}
    {name = "ta"; exec = browser [
      "https://calendar.google.com/calendar/u/0/r/tasks"
      "https://calendar.google.com/calendar/u/0/r"
    ];}
    {name = "rustdesk"; exec = "rustdesk";} # for some reason nix pkg doesn't come with desktop entry?
  ];
in
{
  xdg.desktopEntries = lib.attrsets.mergeAttrsList (
      map (entry: {"${entry.name}" = entry;}) entries  
  );
}
