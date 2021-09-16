# Get-Azure-AD-RefreshToken

## Usage

1. Get access to an Azure-AD-joined device.
2. Get access to the target user context.
2. Check if 'AzureAdPrt' == YES.
```
PS > dsregcmd.exe /status | select-string 'AzureAdPrt :'
```
3. Get a refresh token.
```
PS > .\Get-Azure-AD-RefreshToken.ps1
```
4. Open a browser, go to 'https://login.microsoftonline.com/login.srf' and clean all cookies.
5. Set a new cookie:
- Name: 'x-ms-RefreshTokenCredential'
- Value: data value obtained in step 3
- HttpOnly: true
- Secure: true
6. Go to 'https://login.microsoftonline.com/login.srf' again.


## Credits

- https://github.com/dirkjanm/ROADtoken
- https://github.com/leechristensen/RequestAADRefreshToken
