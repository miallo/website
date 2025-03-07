---
{
   "date": "2025-03-07T10:27:02+01:00",
   "title": "Remote code execution made easy",
   "tags": ["security"],
   "categories": ["Web Development"]
}
---

Git can automate lots of things and run code for you on many of the actions.
That can be very useful to automate e.g. for automatically formatting code
before commiting. But if it executed code automatically - could a malicious
actor use it for attacking you? 🤔

## TL;DR

Executing any git command (either by you, or your tools) in folders you did not
create yourself can be a dangerous!

## Proof of concept

Let's create a repository with the following commands:
```sh
git init malicious
cd malicious
echo "README" > README
git add README
cd ..
{
echo '#!/bin/sh'
echo 'touch xxx'
} > malicious/.git/hooks/post-index-change
chmod +x malicious/.git/hooks/post-index-change

ls malicious # let's see what is inside the folder
```

What did we do?
- We created a repository with the name "malicious" (obviously if you indeed
  were malicious, you would name it differently).
- We created a file "README"
- We _staged_ the file for a commit (but did not do the commit)
- We added a script to the file `.git/hooks/post-index-change` (when executed
  it just creates a file with the name `xxx`, but here you could put some
  really bad stuff…)

You will see that there is **no** file called `xxx` yet.

Now you can e.g. zip this folder and send it to someone and as soon as they
execute e.g.
```sh
git status
```
(It can be either run manually or e.g. if the person you are attacking has a
command promt that shows the git status or their editor of choice has a git
integration e.g. to show lines of code that have changed)
And now if you take another look at the folder you will see that the script we
prepared was executed and now there is the file `xxx`. Well - in this case it
was not that harmful, but a real attacker could put bad things into it…

## What does git do to try to prevent this?

If you clone a repository, there are no of these hooks set, so if you only get
folders using git, you are safe. But if you simply download a folder with your
browser, there can obviously be these scripts, so this approach to blindly
execute scripts, just because the scripts are in the `.git/hooks` folder, is
not a good way to distinguish if it is safe.

Also there are more ways to get code execution with git, than just the hooks.
E.g. in the `.git/config` you can set programs to be executed as pagers, …

## What could git do to really prevent this?

I reported this to the git security mailing list and added a suggestion to only
run code if you created the local copy of the repository on your computer. How
could we do that?

The best way would probably be to (automatically) once create a unique token
for every machine. Then you just put a copy of this token into the .git folder
when you created it (either with `git init` or `git commit`). That way git
could just compare the copy of the token in the .git folder with your global
copy before executing any code. And as long as you don't leak that token, you
are safe now to use git in any place.

I even wrote a wrapper script that does exactly this:
https://gist.github.com/miallo/a88807835ecd4636dc3504ba70ae69e6#file-git-secret-sh
(there is also an alternative approach for doing this based on paths and
keeping a database on allowed paths - both have their pros and cons: Paths
cannot be stolen, but if you previously allowed a path and then move a
malicious folder to the same path you are lost again. In general I think the
"secret" token allows for more flexibility, e.g. moving folders)

BTW: if you are wondering: the answer from the mailing list was "Works as
intended"… :/

## What do I do to mitigate the risk?

I do not want to live without my command line prompt showing me the git status
any more. The situational awareness I get by having the branch name and a very
simplified version of the status is invaluable to me. So in order to make at
least changing directories into downloaded folders safe (yeah - my editor still
could screw me up), I added this check for the token myself before executing
any git command automatically and since you can't just hook into the `init` or
`clone`, I need to run a separate command once for every directory I want my
commandline to show the git status.

Is this just paranoia? _Yes, probably I wouldn't get attacked like this._

Does it protect me from all attacks? _No - it just shows a warning in my prompt
if this is untrusted. My editor could still screw me over, but since I use a
commandline editor (`neovim` if you are curious), I will most likely see the
warning first._

## How did I stumble across this?

I started to create an interactive git tutorial that just uses git
(https://github.com/miallo/nuggit). It only teaches you a single git
instruction and when you execute this, you will get information about the next
steps. In order to show this to the users when they do things like `git
commit`, I started putting all the possible hooks in there and tried what
happens. For `commit`, it was expected, but having a simple `status` execute
commands felt a bit dangerous…
