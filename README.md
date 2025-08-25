# A Tale of two `bash`s

This repo contains a demo of nix being used to dependency-inject different versions of bash.

[test.sh](./test.sh) contains a bash script.
[flake.nix](./flake.nix) defines two apps (to see these, run `nix flake show` at the repo root)

- testbash3-1
- testbash-modern

Each of these apps runs `test.sh` with a different version of bash:
```
$ nix run .#testbash3-1
  Bash 3.1.0(1)-release
  1
  done

$ nix run .#testbash-modern
  Bash 5.3.0(1)-release
  1
  2
  3
  done
```

In neither of these cases was your system's bash used.
Instead the `flake.nix` packaged dedicated versions of bash for use with each app.

In this case we used this to highlight a breaking change that occurred somewhere between bash 3.1.0 and 5.3.0.

# Takeaways

1. Nix does depenency injection for your $PATH, this lets you control what "bash" means so that it's not up to your user's system configuration.
   This goes for any other software dependency as well.
   It's a solution to the "works on my machine" problem.
  

2. Anybody can keep their installed software the same and try out different code.
   Nix makes it easy to keep the code the same and try out different dependencies.
   That's twice as many opportunities for inductive reasoning.
