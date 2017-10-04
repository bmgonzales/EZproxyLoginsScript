X:
cd \audit
$date = get-date
$date = $date.AddDays(-1)
$date = $date.ToString("yyyyMMdd")
$audit = $date + ".txt"
$results = ipcsv $audit -delim "`t" | group IP | ? {($_.group.Event | Out-String) -NotMatch 'Success|Logout|System'} | % {$_.group | sort {date $_.'date/time'} -Descending | select -f 1} | % {$_ | fl * | out-string}
if ($results -ne $null) {
$EmailFrom = "email_address"
$EmailTo = "email_address" 
$Subject = "EZproxy Login Failures" 
$Body = $results 
$SMTPServer = "smtp.gmail.com" 
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
$SMTPClient.EnableSsl = $true 
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("email_name", "email_pw"); 
$SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)
}

exit
