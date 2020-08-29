#!/usr/bin/env python3

import os

sdk_path = "$ANDROID_HOME"

repo_url = "https://animanga.efreakbnc.net/fdroid/repo"
repo_name = "Unofficial Anime/Manga F-Droid Repo"
repo_icon = "fdroid-icon.png"
repo_description = """
This is a repository of open and closed source anime/manga related apps.
Applications in this repository are official binaries built and
signed by their respective developers and copied to this directory.
"""

archive_older = 1
archive_url = "https://animanga.efreakbnc.net/fdroid/archive"
archive_name = "Unofficial Anime/Manga F-Droid Archive"
archive_icon = "fdroid-icon.png"
archive_description = """
This is an archive of open and closed source anime/manga related apps.
Applications in this repository are official binaries built and
signed by their respective developers and copied to this directory.
"""

make_current_version_link = False

# current_version_name_source = 'packageName'

# The ID of a GPG key for making detached signatures for apks. Optional.
# gpgkey = '1DBA2E89'

repo_keyalias = "Lenovo.localdomain"
keystore = os.environ["KEYSTORE"]
keystorepass = os.environ["KEYSTOREPASS"]
keypass = os.environ["KEYPASS"]
keydname = "CN=Lenovo.localdomain, OU=F-Droid"

# The full URL to a git remote repository. You can include
# multiple servers to mirror to by wrapping the whole thing in {} or [], and
# including the servergitmirrors strings in a comma-separated list.
# Servers listed here will also be automatically inserted in the mirrors list.
#
servergitmirrors = {
    'https://github.com/Efreak/nontachi-fdroid',
    'https://gitlab.com/efreak/nontachi-fdroid.git'
}

# Any mirrors of this repo, for example all of the servers declared in
# serverwebroot and all the servers declared in servergitmirrors,
# will automatically be used by the client.  If one
# mirror is not working, then the client will try another.  If the
# client has Tor enabled, then the client will prefer mirrors with
# .onion addresses. This base URL will be used for both the main repo
# and the archive, if it is enabled.  So these URLs should end in the
# 'fdroid' base of the F-Droid part of the web server like serverwebroot.
#
mirrors = (
    'https://animanga.netlify.com/fdroid',
    'https://animanga.cloud.efreakbnc.net/fdroid',
)
