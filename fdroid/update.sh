#!/usr/bin/env bash

#if ! (type curl && type jq && type gh) &>/dev/null; then
#  echo -e 'Please install curl, jq and gh (github.com/cli/cli).'
#  exit 1
#fi

cd $HOME/fdroidserver-nontachi/fdroid/repo

predl="$(ls)"

function get_latest_gh_release(){
    echo "Checking releases for $1"
    gh api "repos/$1/releases"|jq '.[0].assets[].browser_download_url'| fgrep -i .apk |cut -d\" -f2 | while read url; do
        echo "Downloading $url"
        rm -f incoming.apk # clean up because I do stupid things
        curl -sL "$url" --output incoming.apk
        mv -n incoming.apk $(aapt dump badging incoming.apk|head -1|sed -e "s/'/"'"/g' -Ee 's/.*?name="([^"]+)".*?versionCode="([^"]+)".*?versionName="([^"]+)".+/\1_v\3_\2.apk/g')
        rm -f incoming.apk # clean up if last command failed (if the file wasn't actually an apk file for some reason)
        echo
    done
}

get_latest_gh_release 'neverfelly/Meow'
get_latest_gh_release 'avluis/Hentoid'
get_latest_gh_release 'HenryQuan/AnimeGo-Re'
get_latest_gh_release 'KurozeroPB/Nekos'
get_latest_gh_release 'nv95/Kotatsu'
get_latest_gh_release 'Arnab771/Jiyu'
get_latest_gh_release 'Michael24884/TaiYaKiAnime'
get_latest_gh_release 'Sher1234/Horrible'

echo 'Downloading balvinderz/animewatcher from https://github.com/balvinderz/animewatcher/raw/master/app/release/app-release.apk'
curl -s -L 'https://github.com/balvinderz/animewatcher/raw/master/app/release/app-release.apk' --output aw.apk
mv -n aw.apk $(aapt dump badging aw.apk|head -1|sed -e "s/'/"'"/g' -Ee 's/.*?name="([^"]+)".*?versionCode="([^"]+)".*?versionName="([^"]+)".+/\1_v\3_\2.apk/g')

echo 'checking for new versions of cylonu87 apps'
echo 'Checking/Downloading HDLR'
curl -s -L $(curl -s 'https://api.bitbucket.org/2.0/repositories/cylonu87/animedlr/downloads' | jq . | grep -E 'href.*?HDLR-.*?release.apk' -m1|cut -d \" -f4) --output hdlr.apk
mv -n hdlr.apk $(aapt dump badging hdlr.apk|head -1|sed -e "s/'/"'"/g' -Ee 's/.*?name="([^"]+)".*?versionCode="([^"]+)".*?versionName="([^"]+)".+/\1_v\3_\2.apk/g')

echo 'Checking/Downloading AnimeDLR'
curl -s -L $(curl -s 'https://api.bitbucket.org/2.0/repositories/cylonu87/animedlr/downloads' | jq . | grep -E 'href.*?AnimeDLR-.*?-full-release.apk' -m1|cut -d \" -f4) --output adlr.apk
mv -n adlr.apk $(aapt dump badging adlr.apk|head -1|sed -e "s/'/"'"/g' -Ee 's/.*?name="([^"]+)".*?versionCode="([^"]+)".*?versionName="([^"]+)".+/\1_v\3_\2.apk/g')

echo 'Checking/Downloading MangaDLR'
curl -s -L $(curl -s 'https://api.bitbucket.org/2.0/repositories/cylonu87/mangadlr/downloads' | jq . | grep -E 'href.*?MangaDLR-.*?-full_extra-release.apk' -m1|cut -d \" -f4) --output mdlr.apk
mv -n mdlr.apk $(aapt dump badging mdlr.apk|head -1|sed -e "s/'/"'"/g' -Ee 's/.*?name="([^"]+)".*?versionCode="([^"]+)".*?versionName="([^"]+)".+/\1_v\3_\2.apk/g')

echo 'Checking/Downloading Kamuy'
curl -s -L $(curl -s 'https://api.bitbucket.org/2.0/repositories/cylonu87/kamuy/downloads' | jq . | grep -E 'href.*?Kamuy-.*?-full-release.apk' -m1|cut -d \" -f4) --output kamuy.apk
mv -n kamuy.apk $(aapt dump badging kamuy.apk|head -1|sed -e "s/'/"'"/g' -Ee 's/.*?name="([^"]+)".*?versionCode="([^"]+)".*?versionName="([^"]+)".+/\1_v\3_\2.apk/g')

echo 'Checking/Downloading Ranobe'
curl -s -L $(curl -s 'https://api.bitbucket.org/2.0/repositories/cylonu87/ranobe/downloads' | jq . | grep -E 'href.*?Ranobe-.*?-full-release.apk' -m1|cut -d \" -f4) --output ranobe.apk
mv -n ranobe.apk $(aapt dump badging ranobe.apk|head -1|sed -e "s/'/"'"/g' -Ee 's/.*?name="([^"]+)".*?versionCode="([^"]+)".*?versionName="([^"]+)".+/\1_v\3_\2.apk/g')

rm -f {incoming,aw,hdlr,adlr,mdlr,kamuy,ranobe}.apk

#TODO: git stash before dl, and git diff here instead
#no, that's a stupid idea. just dont leave stuff behind
newstuff=$(diff <(echo "$predl") <(ls) | cut -d'>' -f2- -s)

# if there's no new files, then exit
if test -z "$newstuff"
then exit
fi

# alert me
echo 'New files:'
echo "$newstuff"

# and update git
cd $HOME/fdroidserver-nontachi/fdroid
git add repo archive
git commit -m "$(echo $'Update apps: \n\n'"$newstuff")"

# dont push if run in a script.
#test "$1" != nopush && git push

# now update fdroid
#./fdroid.sh update --create-metadata --pretty --use-date-from-apk
#git add repo archive tmp
#git commit --amend --no-edit

# (I should probably consider using --no-sign instead)
