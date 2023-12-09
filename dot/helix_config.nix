{
  theme = "dracula";
  
  editor = {
    line-number = "relative";
    auto-save = true;
    auto-format = true;
    file-picker.hidden = false;
    cursor-shape = {  
      insert = "bar";
      normal = "block";
      select = "underline";
    };
    whitespace.render = "none";
    soft-wrap.enable = true;
  };

  keys = {
    insert = {
      up = "no_op";
      down = "no_op";
      left = "no_op";
      right = "no_op";
      pageup = "no_op";
      pagedown = "no_op";
      home = "no_op";
      end = "no_op";
    };

    normal = {
      up = "no_op";
      down = "no_op";
      left = "no_op";
      right = "no_op";
      pageup = "no_op";
      pagedown = "no_op";
      home = "no_op";
      end = "no_op";
    };
  };  
}

