#!/usr/bin/env bash
# Build Phase Script for removing NSAppTransportSecurity exceptions from Info.plist
# https://gist.github.com/Ashton-W/07654259322e43a2b6a50bb289e72627

set -o errexit
set -o nounset

if [[ -z "${REMOVE_ATS_EXCEPTIONS+SET}" ]]; then
  echo "error: User Defined Build Setting REMOVE_ATS_EXCEPTIONS must be set"
  exit 1
fi

#
remove_ATS_exceptions() {
  if [ "$REMOVE_ATS_EXCEPTIONS" == "YES" ]; then
    local infoplist="$CODESIGNING_FOLDER_PATH/Info.plist"
    local -r ats_present=$(/usr/libexec/PlistBuddy -c "Print :NSAppTransportSecurity" "$infoplist" 2>/dev/null)
    if [ "$ats_present" ]; then
      /usr/libexec/PlistBuddy -c "Delete :NSAppTransportSecurity" "$infoplist"
      touch "$infoplist"
      echo "Removed NSAppTransportSecurity from Info.plist"
    else
      echo "No NSAppTransportSecurity found in Info.plist"
    fi
  else
    echo "REMOVE_ATS_EXCEPTIONS not enabled for $CONFIGURATION. Did not remove NSAppTransportSecurity from Info.plist"
  fi
}

remove_ATS_exceptions
