#!/bin/bash
# Update the CFBundleShortVersionString in the generated Info.plist using the most recent Git tag.
# Source http://www.mokacoding.com/blog/automatic-xcode-versioning-with-git/

git=$(sh /etc/profile; which git)
number_of_commits=$("$git" rev-list HEAD --count)
# git_release_version=$("$git" describe --tags --always --abbrev=0)
# Without abbrev, add commit hash to end to distinguish betas from releases
git_release_version=$("$git" describe --tags --always)

target_plist="$TARGET_BUILD_DIR/$INFOPLIST_PATH"
dsym_plist="$DWARF_DSYM_FOLDER_PATH/$DWARF_DSYM_FILE_NAME/Contents/Info.plist"

for plist in "$target_plist" "$dsym_plist"; do
  if [ -f "$plist" ]; then
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $number_of_commits" "$plist"
    /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${git_release_version#*v}" "$plist"
  fi
done
