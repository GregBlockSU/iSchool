SELECT	USR.UserName,
		USR.EmailAddress,
		SUM(DATEDIFF(n, StartDateTime, EndDateTime)) AS SumActualDurationMinutes,
		COUNT(VC.vc_VidCastID) AS CountOfVidCasts,
		MIN(DATEDIFF(n, StartDateTime, EndDateTime)) AS MinActualDurationMinutes,
		AVG(DATEDIFF(n, StartDateTime, EndDateTime)) AS AvgActualDurationMinutes,
		MAX(DATEDIFF(n, StartDateTime, EndDateTime)) AS MaxActualDurationMinutes
FROM	vc_VidCast AS VC
INNER	JOIN vc_User AS USR ON VC.vc_UserID = USR.vc_UserID
INNER	JOIN vc_Status AS ST ON ST.vc_StatusID = VC.vc_StatusID
WHERE	ST.StatusText = 'FINISHED'
GROUP	BY USR.UserName, USR.EmailAddress
ORDER	BY CountOfVidCasts DESC, USR.UserName

