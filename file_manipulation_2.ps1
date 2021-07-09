<#Checks directory with child directories for files with a certain extension.
Sends a message in slack with the names of the files with the specified extension that have not been 
Written to in the last 25 hours.#>

param (
  [parameter(Mandatory=$true)]
  [string]$Directory,
  [parameter(Mandatory=$true)]
  [string]$Extension,
  [string]$URL
)

$Time = (Get-Date).AddHours(-25)

$Files = Get-ChildItem -Path $Directory -Recurse -Filter *$Extension | Where-Object { $_.LastWriteTime -lt $Time }

if ($Files) {
  $Body = @{ text="The following files are located in $Directory and have not been written to in the last 25 hours: $Files"; } | ConvertTo-Json
  Invoke-WebRequest -Method Post -Uri $URL -Body $Body
}

else {
  Write-Error -Message 'No files found'
}
