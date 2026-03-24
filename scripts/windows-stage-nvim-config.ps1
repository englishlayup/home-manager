$source = Join-Path $PSScriptRoot "..\nvim"
$dest = Join-Path $env:LOCALAPPDATA "nvim"

robocopy $source $dest /MIR /NFL /NDL /NJH /NJS
