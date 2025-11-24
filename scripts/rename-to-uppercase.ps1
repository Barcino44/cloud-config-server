param()

# Convención deseada: SERVICE-NAME en MAYÚSCULAS + optional -env en minúsculas + extension .yaml
# Ejemplo: product-service-dev.yml → PRODUCT-SERVICE-dev.yaml
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
        $base = $f.BaseName
        # Match optional environment suffix: -dev, -prod, -stage (case-insensitive)
        if ($base -match '^(?<service>.+?)(?:-(?<env>dev|prod|stage))?$') {
            $service = $matches['service']
            $env = $matches['env']
            $servicePart = $service.ToUpper()
            if ($env) { $envPart = "-" + $env.ToLower() } else { $envPart = "" }
            $newName = "$servicePart$envPart.yaml"
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
                Write-Host "Already correct: $($f.Name)"
            }
        }
        else {
            Write-Warning "Filename '$($f.Name)' didn't match expected pattern; skipping."
        }
    }
    Write-Host "Renombrado finalizado."
}
catch {
    Write-Error "Error durante el renombrado: $_"
    exit 1
}
