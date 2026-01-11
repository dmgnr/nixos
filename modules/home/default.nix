{ ... }:
{
  imports = [
    ./hypr
    ./programs
  ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    settings = {
      user.name = "dreamgineer";
      user.email = "me@dgnr.us";
    };
    hooks = rec {
      post-commit = ./programs/assets/rebuild_hook.sh;
      update = post-commit;
    };
  };
  # Git diffing tool
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      # Don't run this in non-interactive shells
      # home-manager initialization timeout workaround
      [[ $- == *i* ]] || return

      if [ "$TERM_PROGRAM" != "vscode" ]; then
          [ -f ~/.inshellisense/bash/init.sh ] && source ~/.inshellisense/bash/init.sh
          is && clear
          [ "$ISTERM" != "1" ] && exit
      fi

      nixon() {
        local json_input="$1"
        local tmpfile

        # Create a secure temporary file
        tmpfile=$(mktemp /tmp/nixon.XXXXXX.json) || {
          echo "Failed to create temp file" >&2
          return 1
        }

        # Clean up the file on exit
        trap 'rm -f "$tmpfile"' EXIT

        # Write the JSON input to the file
        printf "%s" "$json_input" > "$tmpfile"

        # Evaluate JSON via nix
        nix-instantiate --eval -E "builtins.fromJSON (builtins.readFile \"$tmpfile\")"

        # Cleanup happens on function exit
      }

    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      a = "nix-alien";
      rebuild = "nix switch";
      frccode = "distrobox enter -n ubuntu -r -- bash /home/dgnr/wpilib/2025/frccode/frccode2025";
    };
  };

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
