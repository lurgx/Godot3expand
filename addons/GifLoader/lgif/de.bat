@echo off
REM Ruta a FFmpeg dentro del mismo directorio del script
set ffmpeg_path=%~dp0\ffmpeg\bin\ffmpeg.exe

REM Rutas de entrada y salida (recibidas como argumentos)
set gif_path=%~1
set output_folder=%~2

REM Crear la carpeta de salida si no existe
if not exist "%output_folder%" (
    mkdir "%output_folder%"
)

REM Extraer los frames del GIF


"%ffmpeg_path%" -i "%gif_path%" -vsync 0 "%output_folder%\an%%1d.png"

REM Verificar si el comando tuvo éxito
if %errorlevel% equ 0 (
    echo Frames extraídos con éxito en: %output_folder%
) else (
    echo Error al extraer los frames.
)
