alias j = just
alias g = gitui
alias up = sudo nixos-rebuild --switch flake ~/nixos#machine

def double [x] {
  $"($x)($x)"
}
