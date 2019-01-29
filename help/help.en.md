Repo Tools
====

Transplant ideas for repository and version management.

    $ hg init repo && cd repo
    $ repo-version
    repo-version: found hg repo without a matching tag or branch
    0.1.0-dev
    $ touch file && hg add file && hg commit -m'initial'
    $ repo-tag
    repo-tag: version 0.1.0 (rev 17ccfd02aa0d)
    repo-tag: set @ bookmark to 0.1.0
    $ repo-version
    0.1.0
    $ touch new
    $ repo-version
    0.1.1-dev
    $ hg bookmark 0.2 && repo-version --dev=alpha
    0.2.0-alpha
    $ hg add new && hg commit -m'new feature'
    $ repo-tag rc
    repo-tag: version 0.2.0-rc (rev 67d3e1563d11)
    $ repo-tag
    repo-tag: version 0.2.0 (rev 67d3e1563d11)
    repo-tag: updated @ bookmark to 0.2.0


Notes
----

* cmd/repo-version is directly useful, but cmd/repo-\* maybe less so; eg. task/tag
* "pristine" means all files are either unmodified or ignored -- no unknown files
* hg alias `ln = log --graph -r'!branch("re:^\.")'`
