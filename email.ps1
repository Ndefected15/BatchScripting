Param(
    [String]$file,
    [String]$to,
    [String]$subject,
    [String]$body
)

# Get current timestamp
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Format subject: capitalize the first letter of each word
$subjectWords = $subject -split ' ' | ForEach-Object { $_.Substring(0,1).ToUpper() + $_.Substring(1) }
$subject = $subjectWords -join ' '

# Format body: capitalize the first letter of the first word and add a period at the end if there isn't one
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

# Append timestamp to the body
$message.Body = "$body`r`nTimestamp: $timestamp"

$attach = New-Object Net.Mail.Attachment($file)
$message.Attachments.Add($attach)

$smtp = New-Object Net.Mail.SmtpClient($smtpserver, 587)
$smtp.EnableSsl = $true
$smtp.Credentials = New-Object System.Net.NetworkCredential('ndefected15@gmail.com', 'efnl vgli zzxq quzv')
$smtp.Send($message)

# Output a message indicating the email was sent along with the timestamp
Write-Output ""
Write-Output ""
Write-Output "The email was sent at: $timestamp"

# Return to the batch file and call :anythingElse
Exit 0
