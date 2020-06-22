#!/usr/bin/env bash

if ! (type curl && type jq) &>/dev/null; then
  echo -e 'Please install curl and jq.'
  exit 1
fi

cd /home/efreak/fdroidserver-nontachi/fdroid/repo

predl="$(ls)"

echo Checking/Downloading Meow
curl -s -L $(curl -s $(curl -s 'https://api.github.com/repos/neverfelly/Meow/releases/latest'|jq '.url'|cut -d\" -f2)|jq '.assets'|grep browser_download_url|cut -d\" -f4) --output meow.apk
mv -n meow.apk $(aapt dump badging meow.apk|head -1|sed -e "s/'/"'"/g' -Ee 's/.*?name="([^"]+)".*?versionCode="([^"]+)".*?versionName="([^"]+)".+/\1_v\3_\2.apk/g')

echo Checking/Downloading Hentoid
curl -s -L $(curl -s $(curl -s 'https://api.github.com/repos/avluis/Hentoid/releases/latest'|jq '.url'|cut -d\" -f2)|jq '.assets'|grep browser_download_url|cut -d\" -f4) --output hentoid.apk
mv -n hentoid.apk $(aapt dump badging hentoid.apk|head -1|sed -e "s/'/"'"/g' -Ee 's/.*?name="([^"]+)".*?versionCode="([^"]+)".*?versionName="([^"]+)".+/\1_v\3_\2.apk/g')

echo checking for new versions of cylonu87 apps
echo Checking/Downloading HDLR
curl -s -L $(curl -s 'https://api.bitbucket.org/2.0/repositories/cylonu87/animedlr/downloads' | jq . | grep -E 'href.*?HDLR-.*?release.apk' -m1|cut -d \" -f4) --output hdlr.apk
mv -n hdlr.apk $(aapt dump badging hdlr.apk|head -1|sed -e "s/'/"'"/g' -Ee 's/.*?name="([^"]+)".*?versionCode="([^"]+)".*?versionName="([^"]+)".+/\1_v\3_\2.apk/g')

echo Checking/Downloading AnimeDLR
curl -s -L $(curl -s 'https://api.bitbucket.org/2.0/repositories/cylonu87/animedlr/downloads' | jq . | grep -E 'href.*?AnimeDLR-.*?-full-release.apk' -m1|cut -d \" -f4) --output adlr.apk
mv -n adlr.apk $(aapt dump badging adlr.apk|head -1|sed -e "s/'/"'"/g' -Ee 's/.*?name="([^"]+)".*?versionCode="([^"]+)".*?versionName="([^"]+)".+/\1_v\3_\2.apk/g')

echo Checking/Downloading MangaDLR
curl -s -L $(curl -s 'https://api.bitbucket.org/2.0/repositories/cylonu87/mangadlr/downloads' | jq . | grep -E 'href.*?MangaDLR-.*?-full_extra-release.apk' -m1|cut -d \" -f4) --output mdlr.apk
mv -n mdlr.apk $(aapt dump badging mdlr.apk|head -1|sed -e "s/'/"'"/g' -Ee 's/.*?name="([^"]+)".*?versionCode="([^"]+)".*?versionName="([^"]+)".+/\1_v\3_\2.apk/g')

echo Checking/Downloading Kamuy
curl -s -L $(curl -s 'https://api.bitbucket.org/2.0/repositories/cylonu87/kamuy/downloads' | jq . | grep -E 'href.*?Kamuy-.*?-full-release.apk' -m1|cut -d \" -f4) --output kamuy.apk
mv -n kamuy.apk $(aapt dump badging kamuy.apk|head -1|sed -e "s/'/"'"/g' -Ee 's/.*?name="([^"]+)".*?versionCode="([^"]+)".*?versionName="([^"]+)".+/\1_v\3_\2.apk/g')

echo Checking/Downloading Ranobe
curl -s -L $(curl -s 'https://api.bitbucket.org/2.0/repositories/cylonu87/ranobe/downloads' | jq . | grep -E 'href.*?Ranobe-.*?-full-release.apk' -m1|cut -d \" -f4) --output ranobe.apk
mv -n ranobe.apk $(aapt dump badging ranobe.apk|head -1|sed -e "s/'/"'"/g' -Ee 's/.*?name="([^"]+)".*?versionCode="([^"]+)".*?versionName="([^"]+)".+/\1_v\3_\2.apk/g')

echo
echo "Checking/Downloading TaiYakiAnime (multiple apks)"
curl -s $(curl -s 'https://api.github.com/repos/Michael24884/TaiYaKiAnime/releases/latest'|jq '.url'|cut -d\" -f2)|jq '.assets'|grep browser_download_url|cut -d\" -f4|fgrep -v x86|fgrep -v arm64|while read taiyakiurl;do
  echo $taiyakiurl
  curl -s -L $taiyakiurl --output taiyaki.apk
  mv -n taiyaki.apk $(aapt dump badging taiyaki.apk|head -1|sed -e "s/'/"'"/g' -Ee 's/.*?name="([^"]+)".*?versionCode="([^"]+)".*?versionName="([^"]+)".+/\1_v\3_\2/g')-$(aapt dump badging taiyaki.apk|fgrep native-code|cut -d\' -f2).apk
done

echo
echo Checking/Downloading AnimeGo-Re
curl -s -L $(curl -s $(curl -s 'https://api.github.com/repos/HenryQuan/AnimeGo-Re/releases/latest'|jq '.url'|cut -d\" -f2)|jq '.assets'|grep browser_download_url|cut -d\" -f4) --output animego.apk
mv -n animego.apk $(aapt dump badging animego.apk|head -1|sed -e "s/'/"'"/g' -Ee 's/.*?name="([^"]+)".*?versionCode="([^"]+)".*?versionName="([^"]+)".+/\1_v\3_\2.apk/g')

rm -f {meow,hentoid,adlr,hdlr,mdlr,kamuy,ranobe,taiyaki,animego}.apk

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
cd /home/efreak/fdroidserver-nontachi/fdroid
git add repo archive
git commit -m "$(echo $'Update apps: \n\n'"$newstuff")"

# dont push if run in a script.
test "$1" != nopush && git push

# now update fdroid
#./fdroid.sh update --create-metadata --pretty --use-date-from-apk
#git add repo archive tmp
#git commit --amend --no-edit

# (I should probably consider using --no-sign instead)
