$ErrorActionPreference = "Stop"
$target = Join-Path $PSScriptRoot "boofcv-linux-amd64.tar.gz"
$expected = "5e53e9f15ac84226c86dbfb179345e15db2dffb157493e9e2f47fe4a529eccab"
$parts = 0..42 | ForEach-Object { Join-Path $PSScriptRoot ("image/boofcv-linux-amd64.tar.gz.part-{0:D3}" -f $_) }
foreach ($part in $parts) { if (-not (Test-Path -LiteralPath $part)) { throw "Missing part: $part" } }
$output = [System.IO.File]::Open($target, [System.IO.FileMode]::CreateNew)
try {
    foreach ($part in $parts) {
        $stream = [System.IO.File]::OpenRead($part)
        try { $stream.CopyTo($output) } finally { $stream.Dispose() }
    }
} finally { $output.Dispose() }
$actual = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash.ToLowerInvariant()
if ($actual -ne $expected) { throw "SHA-256 mismatch: $actual" }
Write-Host "SHA-256 OK. Run: docker load -i boofcv-linux-amd64.tar.gz"
