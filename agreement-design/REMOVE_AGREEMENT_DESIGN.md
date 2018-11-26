
Install and use git-subtree to extract the commits for agreement design

### install git-subtree utility in some tools directory:

```
git clone https://github.com/apenwarr/git-subtree.git
cd git-subtree/
sudo rsync -a ./git-subtree.sh /usr/local/bin/git-subtree
```

### split the github tree
This will create a new branch containing only the subdirectory. 
Change to new project root dir and create a clone of the thing.
```
git clone git@github.com:Crown-Commercial-Service/cmp-design-prototype.git
cd cmp-design-prototype
git subtree split --prefix=agreement-design --branch=ccs-data-model 
```

### create new [git@github.com:Crown-Commercial-Service/ccs-data-model.git](repo on github) and push up
```
git remote remove origin
git remote add origin git@github.com:Crown-Commercial-Service/ccs-data-model.git
git push origin ccs-data-model-only
```


