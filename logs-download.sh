#!/bin/bash

# Script to download worklogs from jira for a specified date range and target user
# It returns a comma sepparated list of jira tikets that had work logged for each date
#

user='dmondejar'
#pass='Serok5733A1!'
#pass='fedR-43p!ehEv&'
pass='EstaesmicontrasenA1!'

month='2020-06'

server='https://tools.skybet.net/jira'
endpoint="${server}/rest/api/2/search"


for day in $(seq -f %02g 01 31)
do
  logdate=${month}-${day}
  
  json="{\"jql\":\"worklogAuthor=${user} AND worklogDate=${logdate}\",\"fields\":[\"key\"]}"

  #echo curl -u $user:$pass -H "'Content-Type: application/json; charset=UTF-8'" -X POST $endpoint -d "'$json'"
  response=$(curl --insecure --silent -u $user:$pass -H 'Content-Type: application/json; charset=UTF-8' -X POST $endpoint -d "{\"jql\":\"worklogAuthor=${user} AND worklogDate=${logdate}\",\"fields\":[\"key\"]}")

  csvout=`echo $response | jq -r '[.issues[].key] | @csv' | tr -d \"`


  echo "$logdate;$csvout"
  

done

