#!/bin/bash
usr=testuser
pass=testpass
jiraHost=https://jiratest.com

# The following file needs to have the format 'jiraTicket,timeInSeconds' per each line
tasksCsvFile=day_tasks.csv

#date='2019-10-17'
date=$(date '+%Y-%m-%d')

#https://docs.atlassian.com/software/jira/docs/api/REST/7.6.1

## now loop through the above array
for i in `cat ${tasksCsvFile} | grep -v ',0'`; do
   task=`echo $i | cut -f1 -d','`
   secs=`echo $i | cut -f2 -d','`

   echo "====== JiraHost: $jiraHost User: $usr Date: $date Task: $task Seconds: $secs"
   echo ""
done


read -p "--> Do you want to proceed? (y/N) " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
   for i in `cat ${tasksCsvFile} | grep -v ',0'`; do
      task=`echo $i | cut -f1 -d','`
      secs=`echo $i | cut -f2 -d','`
      echo "====== SENDING JiraHost: $jiraHost User: $usr Date: $date Task: $task Seconds: $secs"
      # or do whatever with individual element of the array
      curl -u "$usr:$pass" -X POST -H 'Content-Type: application/json' -d "{\"started\":\"${date}T12:00:00.000+0000\",\"timeSpentSeconds\":$secs}" ${jiraHost}/rest/api/2/issue/${task}/worklog
      echo ""
   done
fi

echo "--> Check your timesheets here ${jiraHost}/secure/ConfigureReport.jspa?reportKey=jira-timesheet-plugin:report&showDetails=true&weekends=true"
echo ""
