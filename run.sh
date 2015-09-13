#!/bin/bash

if [ "$WERCKER_RESULT" = "passed" ]; then
  COLOR=green
  RESULT=passed
  NOTIFY=false
else
  COLOR=red
  RESULT=failed
  NOTIFY=true
fi

if [ -n "$DEPLOY" ]; then
  MESSAGE="<a href=\\\"$WERCKER_APPLICATION_URL\\\">$WERCKER_APPLICATION_OWNER_NAME/$WERCKER_APPLICATION_NAME</a>: <a href=\\\"$WERCKER_DEPLOY_URL\\\">deploy</a> to $WERCKER_DEPLOYTARGET_NAME by $WERCKER_STARTED_BY $RESULT."
else
  MESSAGE="<a href=\\\"$WERCKER_APPLICATION_URL\\\">$WERCKER_APPLICATION_OWNER_NAME/$WERCKER_APPLICATION_NAME</a>: <a href=\\\"$WERCKER_BUILD_URL\\\">build</a> of $WERCKER_GIT_COMMIT ($WERCKER_GIT_BRANCH) by $WERCKER_STARTED_BY $RESULT."
fi

JSON="{\"color\":\"$COLOR\",\"message_format\":\"html\",\"notify\":\"$NOTIFY\",\"message\":\"$MESSAGE\"}"
URL="https://api.hipchat.com/v2/room/${WERCKER_HIPCHAT_NOTIFY_ROOM_ID}/notification"

curl -X POST "$URL" -d "$JSON" -H "Content-Type: application/json" -H "Authorization: Bearer $WERCKER_HIPCHAT_NOTIFY_TOKEN"
