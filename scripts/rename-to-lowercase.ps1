param()

# Convención: dejar los nombres en minúsculas y normalizar la extensión a .yml
# Ejemplo: PRODUCT-SERVICE-dev.yaml → product-service-dev.yml
try {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
    $root = Resolve-Path (Join-Path $scriptDir '..')
    Write-Host "Working directory: $root"

    $files = Get-ChildItem -Path $root -File | Where-Object { $_.Extension -in '.yml', '.yaml' }
    if ($files.Count -eq 0) {
        Write-Host "No matching files (.yml/.yaml) found in $root"
        exit 0
    }

    foreach ($f in $files) {
        $baseLower = $f.BaseName.ToLower()
        $newName = "$baseLower.yml"
        if ($f.Name -ne $newName) {
            $destPath = Join-Path -Path $root -ChildPath $newName
            if (Test-Path -LiteralPath $destPath) {
                Write-Warning "Skipping '$($f.Name)' → destination '$newName' already exists."
                continue
            }
            Write-Host "Renaming '$($f.Name)' → '$newName'"
            Rename-Item -LiteralPath $f.FullName -NewName $newName -ErrorAction Stop
        }
        else {
            Write-Host "Already lowercase: $($f.Name)"
        }
    }
    Write-Host "Renombrado a minúsculas finalizado."
}
catch {
    Write-Error "Error durante el renombrado a minúsculas: $_"
    exit 1
}
