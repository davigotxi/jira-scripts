#!/bin/bash

# Script to download worklogs from jira for a specified date range and target user
# It returns a comma sepparated list of jira tikets that had work logged for each date
#

user='<USER>'
pass='<PASS>'

month='2020-05'

server='<SERVER>'
endpoint="${server}/rest/api/2/search"


for day in $(seq -f %02g 01 31)
do
  logdate=${month}-${day}
  response=$(curl --silent -u $user:$pass -H 'Content-Type: application/json; charset=UTF-8' -X POST $endpoint -d "{\"jql\":\"worklogAuthor=${user} AND worklogDate=${logdate}\",\"fields\":[\"key\"]}")
  csvout=`echo $response | jq -r '[.issues[].key] | @csv' | tr -d \"`
  echo "$logdate;$csvout"
done





