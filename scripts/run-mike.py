#!/usr/bin/env python

import logging
import os
import subprocess
import sys

from mike.driver import main as mike_main


# Map of branch names to version names.
#
# Need only include those branches where the title of the version is
# *not* simply the branch name, title-cased.
VERSION_TITLE_MAP = {
    "sto1hs": "Sto1HS",
    "sto2hs": "Sto2HS",
}


def run_mike(args):
    mike_argv = ['mike'] + args + sys.argv[1:]

    logging.debug("Invoking %s", mike_argv)

    sys.argv = mike_argv
    return mike_main()


def main():
    logging.basicConfig(
        level=os.getenv("DOCS_LOGLEVEL", "WARNING").upper()
    )

    # Set the default branch name (all-lowercase)
    mike_default_version_name = os.getenv("DOCS_DEPLOY_DEFAULT_BRANCH", "main")

    # Set the deployment branch name (all-lowercase, defaulting to the
    # current branch) and corresponding Mike version string (title case)
    git_rev_parse = "git rev-parse --abbrev-ref HEAD"
    mike_version_name = os.getenv(
        "DOCS_DEPLOY_BRANCH",
        subprocess.check_output(git_rev_parse,
                                shell=True,
                                encoding=sys.getfilesystemencoding())).strip()
    mike_version_title = VERSION_TITLE_MAP.get(
        mike_version_name,
        mike_version_name.title()
    )

    mike_deploy_args = [
        "deploy",
        "--allow-empty",
        "--title",
        mike_version_title,
        mike_version_name,
    ]
    run_mike(mike_deploy_args)

    # TODO: Re-enable when deploying the mike-versioned docs to production
    mike_set_default_args = [  # noqa: F841
        "set-default",
        mike_default_version_name,
    ]
    # run_mike(mike_set_default_args)


if __name__ == '__main__':
    main()
