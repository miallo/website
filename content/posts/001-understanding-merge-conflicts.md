---
{
   "date": "2025-03-02T00:27:02+01:00",
   "title": "Understanding merge conflicts",
   "tags": ["merge-conflict"],
   "categories": ["Web Development"]
}
---

Did you ever run into a merge conflict (and yes, I will call it _merge_
conflict, even if it occurs during rebases, cherry-picks or reverts as well)
and you didn't know exactly why the conflict happened and the changes where a
bit difficult to understand? There are multiple things that I use in situations
like this:

In case of a rebase I sometimes find it helpful to see the full patch it is
trying to apply, using:
```sh
git rebase --show-current-patch
```

Sometimes this isn't enough, because you also want to understand the other
patches that were involved in creating the merge conflict. There is
```sh
git log --merge
```
It annoyed me that this only worked for merges, so I looked into [the source
code of git](https://web.git.kernel.org/pub/scm/git/git.git/) and added it, so
with git version 2.45.0 this feature now also works for
rebases/cherry-picks/reverts as well. Side-Note: you might or might not know
that for git (and the Linux kernel) there are no normal
Pull-Requests/Merge-Requests like you know them from GitLab/GitHub. Instead
there is a [mailing list](https://lore.kernel.org/git/) and you send emails to
that list. And yes - at least to me this can become a bit confusing with
revisions of certain patches and you also have to be extra careful, because you
can only send emails from certain mail clients…
