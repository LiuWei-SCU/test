$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
$parts = @("boofcv-linux-amd64.tar.gz.part-00", "boofcv-linux-amd64.tar.gz.part-01", "boofcv-linux-amd64.tar.gz.part-02")
$expected = "5e53e9f15ac84226c86dbfb179345e15db2dffb157493e9e2f47fe4a529eccab"
foreach ($part in $parts) { if (-not (Test-Path -LiteralPath $part)) { throw "Missing part: $part" } }
$target = Join-Path $PSScriptRoot "boofcv-linux-amd64.tar.gz"
$output = [System.IO.File]::Open($target, [System.IO.FileMode]::CreateNew)
try {
    foreach ($part in $parts) {
        $inputStream = [System.IO.File]::OpenRead((Join-Path $PSScriptRoot $part))
        try { $inputStream.CopyTo($output) } finally { $inputStream.Dispose() }
    }
} finally { $output.Dispose() }
$actual = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash.ToLowerInvariant()
if ($actual -ne $expected) { throw "SHA-256 mismatch: $actual" }
Write-Host "SHA-256 OK. Load with: docker load -i boofcv-linux-amd64.tar.gz"
