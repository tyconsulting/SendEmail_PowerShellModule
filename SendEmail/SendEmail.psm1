Function Send-Email
{
<# 
 .Synopsis
  Send email notification

 .Description
  Send email notification using .Net System.Net.Mail namespace

 .Parameter -SMTPServer
  SMTP Server Address.

 .Parameter -Port
  SMTP Server Port.

 .Parameter -UseSSL
  Whether or not the SMTP serer requires SSL.

 .Parameter -AuthMethod
  SMTP Server authentication method. possible values: Anonymous, Integrate or Credential

 .Parameter -UserName
  Specify the user name if SMTP server requires credentials (when AuthMethod is set to Credential).

 .Parameter -Password
  Specify the password if SMTP server requires credentials (when AuthMethod is set to Credential).

  .Parameter -SenderName
  Sender name for the email message

  .Parameter -SenderAddress
  Sender address for the email message

  .Parameter -SMTPSettings
  Alternatively, specify a hash table that contacts all of the SMTP settings above

  .Parameter -To
  "To" addresses for the email message. for multiple addresses, separate them using ";".

  .Parameter -Cc
  "Cc" addresses for the email message. for multiple addresses, separate them using ";".

  .Parameter -Bcc
  "Bcc" addresses for the email message. for multiple addresses, separate them using ";".

 .Parameter -Subject
  Subject text for the email message.

 .Parameter -Body
  Email body text.

 .Parameter -HTMLBody
  Whether or not the email body is HTML formatted.

  .Parameter -Attachments
  File path for each attachment for the message. for multiple attachments, separate them using ";".

 .Example
  # Send an email message by specifying each individual SMTP setting:
  $SMTPServer = "SMTP.yourcompany.com"
  $Port = 25
  $AuthMethod = "Anonymous"
  $UseSSL = $false
  $SenderName = "Your System Name"
  $SenderAddress = "your.system@yourcompany.com"
  $Recipient = "you@yourcompany.com"
  $Cc = "user1@yourcompany.com"
  $Bcc = "user2@yourcompany.com"
  $Subject = "Greeting from your Automated email script"
  $Body = @"
Hello,

this is a system generated message

Best Regards,
Your System
"@
  $HTMLBody = $false
  $SendEmail = Send-Email -SMTPServer $SMTPServer -Port $Port -UseSSL $UseSSL -AuthMethod $AuthMethod -SenderName $SenderName -SenderAddress $SenderAddress -To $Recipient -Cc $Cc -Bcc $Bcc -Subject $Subject -Body $Body -HTMLBody $HTMLBody
    

 .Example
  # Send an email message by passing a hashtable containing SMTP settings:
  $SMTPSettings = @{
                    "SMTPServer" = "SMTP.yourcompany.com"
                    "Port" = 25
                    "AuthMethod" = "Credential"
                    "UserName" = "domain\username"
                    "Password" = "password1234"
                    "UseSSL" = $false
                    "SenderName" = "Your System Name"
                    "SenderAddress" = "your.system@yourcompany.com"
                   }
  $Recipient = "you@yourcompany.com"
  $Cc = "user1@yourcompany.com"
  $Bcc = "user2@yourcompany.com"
  $Subject = "Greeting from your Automated email script"
  $Body = @"
Hello,

this is a system generated message

Best Regards,
Your System
"@
  $HTMLBody = $false
  $SendEmail = Send-Email -SMTPSettings $SMTPSettings -To $Recipient -Cc $Cc -Bcc $Bcc -Subject $Subject -Body $Body -HTMLBody $HTMLBody
 
#>
    [CmdletBinding(DefaultParameterSetName='SMTPIndividualSettings')]
    Param (
        [Parameter (ParameterSetName='SMTPIndividualSettings',Mandatory=$true,HelpMessage='Please specify the SMTP Server FQDN')][string]$SMTPServer,
        [Parameter (ParameterSetName='SMTPIndividualSettings',Mandatory=$true,HelpMessage='Please specify the SMTP Server Port')][Int32]$Port,
        [Parameter (ParameterSetName='SMTPIndividualSettings',Mandatory=$true,HelpMessage='Please specify if the SMTP Server requires SSL')][Boolean]$UseSSL,
        [Parameter (ParameterSetName='SMTPIndividualSettings',Mandatory=$true,HelpMessage='SMTP Server Authentication Method, Possible value: Anonymous, Integrated, Credential')][ValidateSet('Anonymous', 'Integrated', 'Credential')][string]$AuthMethod,
        [Parameter (ParameterSetName='SMTPIndividualSettings',Mandatory=$false,HelpMessage='Please specify the user name if the SMTP server requires valid credential')][string]$Username,
        [Parameter (ParameterSetName='SMTPIndividualSettings',Mandatory=$false,HelpMessage='Please specify the password if the SMTP server requires valid credential')][string]$Password,
        [Parameter (ParameterSetName='SMTPIndividualSettings',Mandatory=$true,HelpMessage='Please specify the Sender Name')][string]$SenderName,
        [Parameter (ParameterSetName='SMTPIndividualSettings',Mandatory=$true,HelpMessage='Please specify the Sender Address')][string]$SenderAddress,
        [Parameter (ParameterSetName='SMTPHashTableSettings',Mandatory=$true,HelpMessage='Please specify the SMTP Server settings')][object]$SMTPSettings,
        [Parameter (Mandatory=$true,HelpMessage="Please specify the To Recipients address, separated by ';'")][string]$To,
        [Parameter (Mandatory=$False,HelpMessage="Please specify the Cc Recipients address, separated by ';'")][string]$Cc,
        [Parameter (Mandatory=$False,HelpMessage="Please specify the Bcc Recipients address, separated by ';'")][string]$Bcc,
        [Parameter (Mandatory=$true,HelpMessage='Please specify the email subject')][string]$Subject,
        [Parameter (Mandatory=$true,HelpMessage='Please specify the email subject')][string]$Body,
        [Parameter (Mandatory=$true,HelpMessage='Please specify if the email body is in HTML format')][Boolean]$HTMLBody,
        [Parameter (Mandatory=$false,HelpMessage="Please specify the paths of attachments, separated by ';'")][string]$Attachments
    )

    If ($SMTPSettings)
    {
        [String]$SMTPServer = $SMTPSettings.SMTPServer
        [Int32]$Port = $SMTPSettings.Port
        [Boolean]$UseSSL = $SMTPSettings.UseSSL
        [String]$AuthMethod = $SMTPSettings.AuthenticationMethod
        [String]$UserName = $SMTPSettings.UserName
        [String]$Password = $SMTPSettings.Password
        [String]$SenderName = $SMTPSettings.SenderName
        [String]$SenderAddress = $SMTPSettings.SenderAddress
    }
    Write-Verbose 'SMTP Connection Settings:'
    Write-Verbose "SMTP Server: $SMTPServer"
    Write-Verbose "Port: $Port"
    Write-Verbose "UseSSL: $UseSSL"
    Write-Verbose "Authentication Method: $AuthMethod"
    Write-Verbose "UserName: $UserName"
    Write-Verbose "SenderName: $SenderName"
    Write-Verbose "SenderAddress: $SenderAddress"

    $MailMessage = New-Object System.Net.Mail.MailMessage
    $MailMessage.IsBodyHtml = $HTMLBody
    $SMTPClient = New-Object System.Net.Mail.smtpClient
    $SMTPClient.host =  $SMTPServer
    $SMTPClient.port = $Port
    $SMTPClient.EnableSsl = $UseSSL
    if ($UseSSL)
    {
	    $SMTPClient.EnableSSL = $true
    } elseif ($bSSL -ieq 'false') {
	    $SMTPClient.EnableSSL = $false
    }

    #Get authentication method
    Switch ($AuthMethod)
    {
	    'Anonymous' {$SMTPClient.UseDefaultCredentials = $false}
	    'Integrated' {$SMTPClient.UseDefaultCredentials = $true}
	    'Credential' {
		    #$SMTPClient.UseDefaultCredentials = $true
		    $SMTPUsername = $UserName
		    $SMTPPassword = $Password
		    $SMTPClient.Credentials = New-Object System.Net.NetworkCredential($SMTPUsername, $SMTPPassword)
	    }
    }
        $Sender = New-Object System.Net.Mail.MailAddress($SenderAddress, $SenderName)
        $MailMessage.Sender = $Sender
        $MailMessage.From = $Sender
    
    $MailMessage.Subject = $Subject
	$MailMessage.Body = $Body

    #Get all "To" Recipients
    $arrToRecipients = $To.split(';')
    Foreach ($item in $arrToRecipients)
    {
        $MailMessage.To.Add($item)
    }

    #Get all "Cc" Recipients
    if ($Cc)
    {
        $arrCcRecipients = $Cc.split(';')
        Foreach ($item in $arrCcRecipients)
        {
            $MailMessage.CC.Add($item)
        }    
    }

    #Get all "Bcc" Recipients
    if ($Bcc)
    {
        $arrBccRecipients = $Bcc.split(';')
        Foreach ($item in $arrBccRecipients)
        {
            $MailMessage.BCC.Add($item)
        }    
    }
    
    #Get all attachments
    if ($Attachments)
    {
        $arrAttachments = $Attachments.split(';')
        Foreach ($item in $arrAttachments)
        {
            $MailMessage.Attachments.Add($item)
        }    
    }

    $SMTPClient.Send($MailMessage)
}