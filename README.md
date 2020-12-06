# epitech-git-helper

Epitech helper to manage git repositories

This script contains some useful commands to manage your Epitech repositories using [blih](https://blih.saumon.io/blih.py).

## How to

```
$ ./epitech.sh help
help: show the help
setuser: set the current epitech user account
showuser: show the current epitech user account
new: create a new repository
delete: delete a repository
list: list your repositories
clone <git-flags>: clone a repository
cloneall <git-flags>: clone all your repositories
clean: clean temporary files from emacs
acl: set the acl on a repository
ignore: edit your .gitignore file of your current repository

norm: check your norm
csfml: install the full CSFML library (be careful, contains prohibited functions)
```

`clone` and `cloneall` allow use of git flags, for instance `./epitech.sh cloneall --mirror` will execute a `git clone --mirror <repository>` for each repository you have, allowing you to push of mirror of them to GitHub or GitLab for instance.
