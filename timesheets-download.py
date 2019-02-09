##
# Script to download worklogs from jira for a specified date range and target user
# It returns a comma sepparated list of jira tikets that had work logged for each date
#
import requests
import pprint
import json
from datetime import timedelta, date, datetime
import dateutil.parser
from sets import Set

startDate='2019-02-01'
endDate='2019-02-08'

user='<MyUser>'
passwd='<MyPassword>'

targetUser=user

server='https://<MyJiraServerDomain>'
endpoint='/rest/timesheet-gadget/1.0/raw-timesheet.json?'
params='targetUser='+targetUser+'&startDate='+startDate+'&endDate='+endDate

reqUrl=server+endpoint+params

##Initial dictionary for dates
def daterange(start_date, end_date):
    for n in range(int ((end_date - start_date).days) + 1):
        yield start_date + timedelta(n)

start_date = dateutil.parser.parse(startDate)
end_date = dateutil.parser.parse(endDate)
dates_dic = {}

for single_date in daterange(start_date, end_date):
    dateStr = single_date.strftime("%Y-%m-%d")
    dates_dic[dateStr] = Set()

##
# Make the request to jira
#
r = requests.get(reqUrl, auth=(user, passwd))
x = json.loads(r.text)
for t in x["worklog"]:
  #pprint.pprint(ticket)
  ticket_name = t["key"]
  #pprint.pprint(ticket_name)
  for e in t["entries"]:
    # Need to divide by 1000 as the json returns ms and the method expects seconds
    t_date = datetime.fromtimestamp(e["startDate"]/1000.0).strftime("%Y-%m-%d")
    #pprint.pprint(t_date)
    dates_dic[t_date].add(ticket_name)


#pprint.pprint(dates_dic)
for d in sorted(dates_dic.keys()):
  #print d + "; " + ", ".join(dates_dic[d])
  print ", ".join(dates_dic[d])

