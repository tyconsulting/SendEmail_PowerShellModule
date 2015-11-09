# SendEmail_PowerShellModule

## Description

The SendEmail PowerShell module is a simple module that can be used in PowerShell alone, or in SMA and Azure Automation. Users can either specify individual SMTP server parameters or leveraging the "SMTPServerConnection" connection asset in SMA and Azure Automation.

#Note:
This module was previously published on Tao Yang's blog: http://blog.tyang.org/2014/10/31/simplified-way-send-emails-mobile-push-notifications-sma/

##Installation

### From GitHub Releases
1. Download the SendEmail-master.zip file.
2. Unblock the zip file (right click and select unblock).
3. Extract zip contents SendEmail-master.zip file.
4. Copy SendEmail sub folder with contents to a folder listed in PSModulePath environment variable (such as 'C:\Program Files\WindowsPowerShell\Modules').

### From PowerShell Gallery
To install from PowerShell Gallery
1. Open the PowerShell console as an administrator
2. Run 'Install-Module SendEmail'

### Usage
You can use 'Get-Command -Module SendEmail' to list the available commands within the "SendEmail" module. Currently, it has only one command: 'Send-Email'.

You man use "Get-Help Send-Email -Full" to access the full help file for the 'Send-Email' Command.

PS C:\> Get-Help Send-Email -full

NAME
    Send-Email

SYNOPSIS
    Send email notification

SYNTAX
    Send-Email -SMTPServer <String> -Port <Int32> -UseSSL <Boolean> -AuthMethod <String> [-Username <String>] [-Password <String>] -SenderName <String> -SenderAddress <String> -To <String> [-Cc <String>] [-Bcc <String>] -Subject
    <String> -Body <String> -HTMLBody <Boolean> [-Attachments <String>] [<CommonParameters>]

    Send-Email -SMTPSettings <Object> -To <String> [-Cc <String>] [-Bcc <String>] -Subject <String> -Body <String> -HTMLBody <Boolean> [-Attachments <String>] [<CommonParameters>]


DESCRIPTION
    Send email notification using .Net System.Net.Mail namespace


PARAMETERS
    -SMTPServer <String>

        Required?                    true
        Position?                    named
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -Port <Int32>

        Required?                    true
        Position?                    named
        Default value                0
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -UseSSL <Boolean>

        Required?                    true
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -AuthMethod <String>

        Required?                    true
        Position?                    named
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -Username <String>

        Required?                    false
        Position?                    named
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -Password <String>

        Required?                    false
        Position?                    named
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -SenderName <String>

        Required?                    true
        Position?                    named
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -SenderAddress <String>

        Required?                    true
        Position?                    named
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -SMTPSettings <Object>

        Required?                    true
        Position?                    named
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -To <String>

        Required?                    true
        Position?                    named
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -Cc <String>

        Required?                    false
        Position?                    named
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -Bcc <String>

        Required?                    false
        Position?                    named
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -Subject <String>

        Required?                    true
        Position?                    named
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -Body <String>

        Required?                    true
        Position?                    named
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -HTMLBody <Boolean>

        Required?                    true
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -Attachments <String>

        Required?                    false
        Position?                    named
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

INPUTS

OUTPUTS

    -------------------------- EXAMPLE 1 --------------------------

    PS C:\># Send an email message by specifying each individual SMTP setting:


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
    $SendEmail = Send-Email -SMTPServer $SMTPServer -Port $Port -UseSSL $UseSSL -AuthMethod $AuthMethod -SenderName $SenderName -SenderAddress $SenderAddress -To $Recipient -Cc $Cc -Bcc $Bcc -Subject $Subject -Body $Body -HTMLBody
    $HTMLBody





    -------------------------- EXAMPLE 2 --------------------------

    PS C:\># Send an email message by passing a hashtable containing SMTP settings:


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
