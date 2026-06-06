@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM Crear carpetas si no existen
if not exist "espera" mkdir espera
if not exist "listo" mkdir listo

echo Procesando archivos...
echo.

REM Crear un archivo temporal con el script de PowerShell
(
echo $carpetaEspera = 'espera'
echo $carpetaListo = 'listo'
echo.
echo Get-ChildItem $carpetaEspera -File ^| ForEach-Object {
echo     $archivo = $_.Name
echo     $sinext = $_.BaseName
echo     $extension = $_.Extension
echo.
echo     $nuevo = $sinext
echo.
echo     # Eliminar (SPOTISAVER)
echo     $nuevo = $nuevo -replace '\(SPOTISAVER\)', ''
echo.
echo     # Limpiar acentos
echo     $nuevo = $nuevo -replace 'á', 'a'
echo     $nuevo = $nuevo -replace 'é', 'e'
echo     $nuevo = $nuevo -replace 'í', 'i'
echo     $nuevo = $nuevo -replace 'ó', 'o'
echo     $nuevo = $nuevo -replace 'ú', 'u'
echo     $nuevo = $nuevo -replace 'ñ', 'n'
echo     $nuevo = $nuevo -replace 'à', 'a'
echo     $nuevo = $nuevo -replace 'è', 'e'
echo     $nuevo = $nuevo -replace 'ì', 'i'
echo     $nuevo = $nuevo -replace 'ò', 'o'
echo     $nuevo = $nuevo -replace 'ù', 'u'
echo     $nuevo = $nuevo -replace 'ä', 'a'
echo     $nuevo = $nuevo -replace 'ë', 'e'
echo     $nuevo = $nuevo -replace 'ï', 'i'
echo     $nuevo = $nuevo -replace 'ö', 'o'
echo     $nuevo = $nuevo -replace 'ü', 'u'
echo     $nuevo = $nuevo -replace 'â', 'a'
echo     $nuevo = $nuevo -replace 'ê', 'e'
echo     $nuevo = $nuevo -replace 'î', 'i'
echo     $nuevo = $nuevo -replace 'ô', 'o'
echo     $nuevo = $nuevo -replace 'û', 'u'
echo.
echo     # Eliminar caracteres especiales (mantener solo letras, números, - y .)
echo     $nuevo = [System.Text.RegularExpressions.Regex]::Replace($nuevo, '[^a-zA-Z0-9\-\.]', '')
echo.
echo     # Limpiar espacios
echo     $nuevo = $nuevo -replace '\s+', ' '
echo     $nuevo = $nuevo.Trim()
echo.
echo     # Invertir si contiene ' - '
echo     if ($nuevo -match '^(.+?)\s*-\s*(.+)$') {
echo         $parte1 = $matches[1].Trim()
echo         $parte2 = $matches[2].Trim()
echo         $nuevo = "$parte2 - $parte1"
echo     }
echo.
echo     if ($nuevo) {
echo         try {
echo             $rutaOrigen = Join-Path $carpetaEspera $archivo
echo             $rutaDestino = Join-Path $carpetaListo "$nuevo$extension"
echo             Move-Item -Path $rutaOrigen -Destination $rutaDestino -Force
echo             Write-Host "[OK] $archivo --^> $nuevo$extension"
echo         } catch {
echo             Write-Host "[ERROR] No se pudo procesar: $archivo" -ForegroundColor Red
echo         }
echo     }
echo }
) > "%temp%\procesar.ps1"

REM Ejecutar el script de PowerShell
powershell -ExecutionPolicy Bypass -File "%temp%\procesar.ps1"

REM Limpiar archivo temporal
del "%temp%\procesar.ps1"

echo.
echo Proceso completado. Archivos en la carpeta "listo"
pause
