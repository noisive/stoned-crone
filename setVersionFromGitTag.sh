#!/bin/bash
# Update the CFBundleShortVersionString in the generated Info.plist using the most recent Git tag.
# Idea taken from http://tinyurl.com/3usjj9d by Joachim Bondo.

# Get the current release description from Git.
# GIT_RELEASE_SHORT_VERSION=`git describe --tags | awk '{split($0,a,\"-\"); print a[1]}'`
GIT_CURRENT_COMMIT_TAG=`git tag --points-at HEAD`
# If the current head is untagged, is not a release. So specify beta, to prevent inconsistencies.
if [ $GIT_CURRENT_COMMIT_TAG == "" ]; then
    GIT_RELEASE_SHORT_VERSION="BETA"
else
    GIT_RELEASE_VERSION=$GIT_CURRENT_COMMIT_TAG
fi

# Set the CFBundleShortVersionString in the generated Info.plist (stripping off the leading \"v\").
defaults write \"${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH%.*}\" \"CFBundleShortVersionString\" \"$GIT_RELEASE_SHORT_VERSION\"
defaults write \"${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH%.*}\" \"CFBundleVersion\" \"$GIT_RELEASE_VERSION\"

touch \"${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH%.*}.plist\"
