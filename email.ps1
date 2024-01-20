Param(
    [String]$file,
    [String]$to,
    [String]$subject,
    [String]$body
)

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$subjectWords = $subject -split ' ' | ForEach-Object { $_.Substring(0,1).ToUpper() + $_.Substring(1) }
$subject = $subjectWords -join ' '

$bodyWords = $body -split ' ' | ForEach-Object { $_.Substring(0,1).ToUpper() + $_.Substring(1) }
$body = $bodyWords -join ' '
if (-not $body.EndsWith(".")) {
    $body += "."
}

$smtpserver = "smtp.gmail.com"
$message = New-Object System.Net.Mail.MailMessage
$message.From = 'Ndefected15@gmail.com'
$message.To.Add($to)
$message.Subject = $subject

$message.Body = "$body`r`nTimestamp: $timestamp"

$attach = New-Object Net.Mail.Attachment($file)
$message.Attachments.Add($attach)

$smtp = New-Object Net.Mail.SmtpClient($smtpserver, 587)
$smtp.EnableSsl = $true
$smtp.Credentials = New-Object System.Net.NetworkCredential('ndefected15@gmail.com', 'efnl vgli zzxq quzv')
$smtp.Send($message)

Write-Output ""
Write-Output ""
Write-Output "The email was sent at: $timestamp"

Exit 0
