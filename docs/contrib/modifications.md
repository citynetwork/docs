# Modifying content on this site

You have two options for editing content: directly in your browser
using GitHub, or using a Git-based workflow from your local work
environment.


## Modifying content from your browser

Every page on this site has an Edit button 🖍️. If you click it, it’ll
take you straight to the corresponding source page in GitHub. Then,
you can follow [GitHub’s
documentation](https://docs.github.com/en/repositories/working-with-files/managing-files/editing-files#editing-files-in-another-users-repository)
on how to propose changes to another user’s repository.


## Modifying content using Git

The Git repository for this site lives at <{{ config.repo_url }}>. You
can [fork that
repository](https://docs.github.com/en/get-started/quickstart/fork-a-repo),
make the proposed changes in your fork, and then send us a standard
[GitHub pull
request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests).

For this purpose, use `git` in combination with either GitHub's web
interface, or the `gh` command-line interface (CLI).

First, create a fork of the documentation repository:

=== "`git` client and web browser"
    Open <{{ config.repo_url }}> and click the *Fork* button.
    When you create your new fork, it's fine to leave the
    *Copy the `main` branch only* option enabled.
    
    Then, proceed to create a new local checkout of your fork:
    ```bash
    git clone git@github.com:<yourusername>/<your-repo-fork> {{ config.extra.brand | lower }}-docs
    cd {{ config.extra.brand | lower }}-docs
    ```
=== "`gh` client"
    ```bash
    gh repo fork --clone {{ config.repo_url }} -- {{ config.extra.brand | lower }}-docs
    cd {{ config.extra.brand | lower }}-docs
    ```
    
Next, create a local topic branch and make your modifications:
    
```bash
git checkout -b <your-topic-branch-name>
# edit your files
git add <files-to-add>
git commit
```

Please see our [notes on commit messages](../quality).

Finally, create a pull request (PR) from your changes:

=== "`git` client and web browser"
    Run the following `git` command (assuming `origin` is the
    remote that points to your fork):
    ```bash
    git push origin <your-topic-branch-name>
    ```
    Then, open your browser to the URL suggested by the `git push`
    command, and proceed to create a pull request.
=== "`gh` client"
    ```bash
    gh pr create --fill
    ```

## Monitoring changes as you edit

To see your changes as you work on them, you can use
[tox](https://tox.wiki/en/latest/). Having created a topic branch with
your modifications, run:

```bash
cd {{ config.extra.brand | lower }}-docs
git checkout <your-topic-branch-name>
tox -e serve
```

A local copy of the documentation will then run on your local machine
and be accessible from <http://localhost:8000> in your browser.

When you are planning to make several changes in rapid succession, you
may want to speed up rendering the site after each change. You may do
so by disabling a plugin that checks all links (including external
links) for accessibility:

```bash
cd {{ config.extra.brand | lower }}-docs
export DOCS_ENABLE_HTMLPROOFER=false
tox -e serve
```
