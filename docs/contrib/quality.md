# Quality checks

There are a few checks that we apply to the configuration of this
site. These checks run automatically via GitHub Actions workflows when
you [send your PR](modifications.md):

* We check the commit message with
  [gitlint](https://jorisroovers.com/gitlint/), and enforce the
  [Conventional
  Commits](https://www.conventionalcommits.org/en/v1.0.0/) commit
  message style.
* We check whether the documentation still builds correctly, with your
  change applied.
* We apply [pymarkdownlnt](https://github.com/jackdewinter/pymarkdown)
  checks for Markdown consistency and to encourage some good
  documentation practices.
* We check to make sure that no internal or external links in the
  documentation are dead. This is one example where the checks might
  fail through no fault of yours — some external link may have
  disappeared between the most recent change and your contribution, by
  pure coincidence. When that happens, we’ll fix it together.
* We check some YAML conventions with
  [yamllint](https://yamllint.readthedocs.io/en/stable/). However,
  most contributions would probably only touch Markdown files and not
  YAML, so you’re unlikely to trip over this.

If you’re working in your local Git repository and your work
environment has [tox](https://tox.wiki/en/latest/) installed, you can
also run the checks locally:

```bash
tox
```

You can also configure your local checkout to run quality checks on
each commit. To do that, run:

```bash
git config core.hooksPath .githooks
```

