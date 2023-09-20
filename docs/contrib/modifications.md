# Modifying content on this site

You have two options for editing content: directly in your browser using GitHub, or from your local work environment using a Git-based workflow.

## Notes on content additions

**Sections:** Generally, content additions should fit somewhere within the existing top-level and second-level sections (like [_Background_](../background/index.md), or [_Kubernetes_](../howto/kubernetes/index.md)).
Try not to introduce a new top-level or second-level section.

**Text:** Write your Markdown text in such a way that each sentence in a paragraph has its own line, and is followed immediately by a newline character with no spaces in between.
This facilitates the review of your change, and it also helps you notice long run-on sentences as you write.

**Headings:** Keep headings concise, under 80 characters.

**Screenshots:** If you are contributing a change that contains screenshots from {{gui}}, they should have a resolution of 1920×1080 pixels (1080p).
If your screen has a larger resolution, use [Firefox Responsive Design Mode](https://firefox-source-docs.mozilla.org/devtools-user/responsive_design_mode/)
or [Chrome/Chromium Device Mode](https://developer.chrome.com/docs/devtools/device-mode/) to configure your browser with 1080p.

Screenshots should be added to a directory named `assets`, located in the same directory as the Markdown file you are adding or editing.

**CLI screen dumps:** If you are contributing a change that contains a screen dump from the `openstack` command-line client, please limit its width to 100 characters.
You can do this by setting the following environment variable in your terminal, before you start working on your change.

``` bash
export CLIFF_MAX_TERM_WIDTH=100
```

**Renamed sources:** If you rename an existing Markdown source, the path of the rendered page's [URI](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier) will change.
In this case, be sure to define a [redirect](https://github.com/mkdocs/mkdocs-redirects) from the old URI to the new one, by adding an entry to the `plugins.redirect.redirect_maps` dictionary in the `mkdocs.yml` configuration file.

## Modifying content from your browser

Every page on this site has an Edit button ([:{{config.theme.icon.edit | replace('/','-')}}:]({{page.edit_url}})).
If you click it, it’ll take you straight to the [corresponding source page]({{page.edit_url}}) in GitHub.
Then, you can follow [GitHub’s documentation](https://docs.github.com/en/repositories/working-with-files/managing-files/editing-files#editing-files-in-another-users-repository) on how to propose changes to another user’s repository.

## Modifying content using Git

The Git repository for this site lives [on GitHub]({{config.repo_url}}).
You can [fork that repository](https://docs.github.com/en/get-started/quickstart/fork-a-repo), make the proposed changes in your fork, and then send us a standard [GitHub pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests).

For this purpose, use `git` in combination with either GitHub's web interface, or the `gh` command-line interface (CLI).

First, create a fork of the documentation repository:

=== "`git` client and web browser"
    Open [our GitHub repo]({{config.repo_url}}) and click the *Fork* button.
    When you create your new fork, it's fine to leave the *Copy the `main` branch only* option enabled.

    Then, proceed to create a new local checkout of your fork:
    ```bash
    git clone git@github.com:<yourusername>/<your-repo-fork> {{ brand | lower }}-docs
    cd {{ brand | lower }}-docs
    ```
=== "`gh` client"
    ```bash
    gh repo fork --clone {{ config.repo_url }} -- {{ brand | lower }}-docs
    cd {{ brand | lower }}-docs
    ```

Next, create a local topic branch and make your modifications:

```bash
git checkout -b <your-topic-branch-name>
# edit your files
git add <files-to-add>
git commit
```

Please see our [notes on commit messages](quality.md).

Finally, create a pull request (PR) from your changes:

=== "`git` client and web browser"
    Run the following `git` command (assuming `origin` is the remote that points to your fork):
    ```bash
    git push origin <your-topic-branch-name>
    ```
    Then, open your browser to the URL suggested by the `git push` command, and proceed to create a pull request.
=== "`gh` client"
    ```bash
    gh pr create --fill
    ```

## Monitoring changes as you edit

To see your changes as you work on them, you can use [tox](https://tox.wiki/en/latest/).
Having created a topic branch with your modifications, run:

```bash
cd {{ brand | lower }}-docs
git checkout <your-topic-branch-name>
tox -e serve
```

A local copy of the documentation will then run on your local machine and be accessible from <http://localhost:8000> in your browser.

When planning to make several changes in rapid succession, you may want to speed up site rendering after each change.
You may do so by disabling a plugin that checks all links (including external links) for accessibility:

```bash
cd {{ brand | lower }}-docs
export DOCS_ENABLE_HTMLPROOFER=false
tox -e serve
```

## Commit messages

When you submit a change, you will need to provide a commit message, which is very nearly as important as the change itself.
Excellent guides on what constitutes a good commit message are available from [Tim Pope](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html) and [Colleen Murphy](http://www.gazlene.net/getting-work-done-in-open-source.html).

In addition, we have adopted the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) style for commit message subjects.
Please make sure that your commit message starts with one of the following prefixes:

* `feat:` denotes a content addition, such as adding documentation for some {{brand}} functionality that was not included in the documentation before.
* `fix:` denotes a content correction, such as fixing a documentation bug.
* `build:` denotes a change to the build process, such as an improvement to a CI check.
* `chore:` denotes a minor change that is neither a feature, nor a fix, nor a build improvement, such as when you edit the `.mailmap` file.
* `docs:` denotes a change to the documention *for* this site, such as an update to the `README.md` file.
