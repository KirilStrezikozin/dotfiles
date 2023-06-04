# heiskempler's dotfiles

Send myself to hell if I lose em (dotfiles).

Original idea of configuring config files in the way I did belongs to [Atlassian: How to Store Dotfiles - A Bare Git Repository](https://www.atlassian.com/git/tutorials/dotfiles).

## Note for myself about how to pull

Sync:
```
dotfiles pull
```

Brand-new:

```
git clone --bare https://github.com/KirilStrezikozin/dotfiles $HOME/dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
dotfiles checkout
dotfiles config status.showUntrackedFiles no
```

