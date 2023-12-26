Param(

    [String]$file,

    [String]$to,

    [String]$subject,

    [String]$body

    )

"$body"

$smtpserver = "smtp.gmail.com" 

$message = new-object System.Net.Mail.MailMessage

$message.From = 'Ndefected15@gmail.com'

$message.To.Add($to)

$message.Subject = $subject

$attach = new-object Net.Mail.Attachment($file)

$message.Attachments.Add($attach)

$message.body = "$body"

$smtp = new-object Net.Mail.SmtpClient($smtpserver, 587)

$smtp.EnableSsl = $true

$smtp.Credentials = New-Object System.Net.NetworkCredential('ndefected15@gmail.com', 'app-pw')

$smtp.Send($message)


""
""
"The email was sent!"