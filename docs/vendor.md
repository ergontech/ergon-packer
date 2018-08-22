# Vendor Workflow

## Adding Packer to your project
```
$ ls packer/
ls: packer/: No such file or directory

$ git checkout -b feature/add-packer

$ git remote add -f ergon-packer git@github.com:ergontech/ergon-packer.git
Updating ergon-packer
From github.com:ergontech/ergon-packer
 * [new branch]      master     -> ergon-packer/master

$ git subtree add --prefix=packer --squash ergon-packer master
git fetch ergon-packer master
remote: Counting objects: 6, done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 6 (delta 3), reused 5 (delta 3), pack-reused 0
Unpacking objects: 100% (6/6), done.
From github.com:ergontech/ergon-packer
 * branch            master     -> FETCH_HEAD
   7122ab5..d277dcb  master     -> ergon-packer/master
Added dir 'packer'

$ ls packer/
README.md        amazon.json      http/            scripts/       virtualbox.json
```

## Pulling changes downstream
Make some changes to `virtualbox.json`
```
$ vim packer/virtualbox.json
```

Attempt to pull down latest master, but it fails
```
$ git fetch ergon-packer
$ git subtree pull --prefix=packer --squash ergon-packer master
Working tree has modifications.  Cannot add.
```

It fails since we have made changes to a file within the subtree and they have not been staged or committed
```
$ git diff
diff --git a/packer/virtualbox.json b/packer/virtualbox.json
index 3e56ac5..9eac68c 100644
--- a/packer/virtualbox.json
+++ b/packer/virtualbox.json
@@ -1,7 +1,8 @@
 {
    "variables": {
         "version": "0.0.{{timestamp}}",
         -    "groups": ""
         -    +    "groups": "",
         -    +    "testing": ""
         -       },
         -          "builders": [
         -               {
```

Stage and commit our changes
```
$ git add packer/virtualbox.json

$ git commit -m'add testing'
[feature/packer 7c6a977] add testing
 1 file changed, 2 insertions(+), 1 deletion(-)
```

Attempt again to pull down latest master, it fails
```
$ git fetch ergon-packer
$ git subtree pull --prefix=packer --squash ergon-packer master
warning: no common commits
remote: Counting objects: 37, done.
remote: Compressing objects: 100% (25/25), done.
remote: Total 37 (delta 10), reused 35 (delta 8), pack-reused 0
Unpacking objects: 100% (37/37), done.
From github.com:ergontech/ergon-packer
 * branch            master     -> FETCH_HEAD
Auto-merging packer/virtualbox.json
CONFLICT (content): Merge conflict in packer/virtualbox.json
Automatic merge failed; fix conflicts and then commit the result.
```

It fails since our changes and upstream changes conflict
```
$ git diff
diff --cc packer/virtualbox.json
index 9eac68c,9887ea5..0000000
--- a/packer/virtualbox.json
+++ b/packer/virtualbox.json
@@@ -1,8 -1,8 +1,14 @@@
  {
      "variables": {
      ++<<<<<<< HEAD
       +    "version": "0.0.{{timestamp}}",
        +    "groups": "",
         +    "testing": ""
         ++=======
         +     "environment": "",
         +     "groups": "",
         +     "version": "0.0.{{timestamp}}"
         ++>>>>>>> 7c9a2795969f9c5aa496961f538e27ec51f21159
             },
                 "builders": [
                       {
```

Manually resolve conflict
```
$ vim packer/virtualbox.json
```

Add the file and finish the merge
```
$ git add packer/virtualbox.json

$ git commit
[feature/packer 1162783] Merge commit
'7c9a2795969f9c5aa496961f538e27ec51f21159' into feature/packer
```

## Passing changes upstream
Manually make some changes
```
$ vim packer/.envrc
$ vim packer/.gitignore

$ git diff
diff --git a/packer/.envrc b/packer/.envrc
index da42f57..f8339c7 100644
--- a/packer/.envrc
+++ b/packer/.envrc
@@ -11,3 +11,9 @@ then
     export AWS_ACCESS_KEY=$(AWS_PROFILE=$AWS_PROFILE aws configure get aws_access_key_id)
     export AWS_SECRET_KEY=$(AWS_PROFILE=$AWS_PROFILE aws configure get aws_secret_access_key)
 fi
+
+# source local variables
+if [ -f .envrc.local ]
+then
+    dotenv .envrc.local
+fi
diff --git a/packer/.gitignore b/packer/.gitignore
index c28e9b1..9fe2a2e 100644
--- a/packer/.gitignore
+++ b/packer/.gitignore
@@ -5,3 +5,6 @@
 builds/*.box
 packer_cache
 output-*
+
+# direnv
+.envrc.local
```

Stage and commit changes to upstream files
```
$ git add packer/.envrc packer/.gitignore

$ git commit -m'add support for local envdir'
[feature/packer 3e87719] add support for local envdir
 2 files changed, 9 insertions(+)
```

Push the subtree to a new branch on the ergon-packer repository
```
$ git subtree push --prefix=packer ergon-packer feature/local-direnv
git push using:  ergon-packer feature/local-direnv
Enumerating objects: 7, done.
Counting objects: 100% (7/7), done.
Delta compression using up to 8 threads.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 440 bytes | 440.00 KiB/s, done.
Total 4 (delta 2), reused 0 (delta 0)
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
To github.com:ergontech/ergon-packer
 * [new branch]      8eaec8c469c6d8403d0b0a72810f786a4db66d9e -> feature/local-direnv
```

Then visit the ergon-packer repository and open a Pull Request against the master branch
