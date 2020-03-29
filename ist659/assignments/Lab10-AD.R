# Ready RODBC for use in this script
require(RODBC)
# Create a connection to SQL Server using our 64-bit DSN
myconn <-odbcConnect("VidCast64")
if (myconn==-1) {
  print('No connection')
}

# Ready the SQL to send to the server
sqlSelectStatement <-
  "SELECT
vc_VidCast.vc_VidCastID
, vc_VidCast.VidCastTitle
, DATEPART(dw, StartDateTime) as StartDayofWeek
, DATEDIFF(n, StartDateTime, EndDateTime) as ActualDuration
, ScheduleDurationMinutes
, vc_User.vc_UserID
, vc_User.UserName
FROM vc_VidCast
JOIN vc_User ON vc_User.vc_UserID = vc_VidCast.vc_UserID
"
sqlSelectStatement

#Send the request to the server and store the results in a variable
sqlResult <-sqlQuery(myconn, sqlSelectStatement)
sqlResult

if (class(sqlResult) != 'data.frame')
#Create a list of days of the week for charting later
days <- c("Sun", "Mon", "Tue", "Weds", "Thurs", "Fri", "Sat")

#Create a histogram of durations (appears in the Plots tab)
hist(sqlResult$ActualDuration, 
     main="How long are the VidCasts?", 
     xlab = "Minutes",
     ylab = "VidCasts",
     border = "blue",
     col = "grey",
     labels=TRUE
)

#Plot a bar chart of video counts by day of the week
dayCounts <-table(sqlResult$StartDayofWeek)
barplot(dayCounts,
        main = "VidCasts by Day of Week", 
        ylab = "Day of Week",
        xlab = "Count of VidCasts",
        border = "blue",
        names.arg = days
)

# Close all connections
odbcCloseAll()


