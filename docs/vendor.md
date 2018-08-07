# Vendor Workflow

## Adding Packer to your project
```
$ ls packer/
ls: packer/: No such file or directory

$ git checkout -b feature/add-packer

$ git subtree add --prefix=packer --squash git://github.com/ergontech/ergon-packer.git master
git fetch git://github.com/ergontech/ergon-packer.git master
From git://github.com/ergontech/ergon-packer
 * branch            master     -> FETCH_HEAD
Added dir 'packer'

$ ls packer/
README.md        amazon.json      http/            scripts/       virtualbox.json
```

## Pulling changes downstream
TODO

## Passing changes upstream
TODO
