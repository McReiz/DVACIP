@echo off
setlocal enabledelayedexpansion

:: 1. Verificar si pasaste el nombre como parámetro (ej: mi_script.bat musica.txt)
set "nombre_archivo=%~1"

:: 2. Si no pasaste parámetro, el script te preguntará el nombre
if "%nombre_archivo%"=="" (
    set /p "nombre_archivo=Introduce el nombre del archivo (ej: canciones.txt): "
)

:: 3. Definir la ruta completa dentro de la carpeta /list
set "ruta_completa=list\%nombre_archivo%"

:: 4. Verificar si el archivo existe
if not exist "%ruta_completa%" (
    echo.
    echo ERROR: No se encuentra el archivo en: %ruta_completa%
    pause
    exit
)

echo.
echo Leyendo: %ruta_completa%
echo ---------------------------------

:: 5. Bucle para procesar el archivo
for /f "usebackq tokens=1,2 delims=|" %%a in ("%ruta_completa%") do (
    echo Procesando: %%b
    python _download-and-convert--audacity.02.py --video_url="%%a" --folder_name="%%b"
    echo ---------------------------------
)

pause
