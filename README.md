# GIF to MP4 Converter V1.0 para Aseprite

Este script permite convertir animaciones GIF creadas en **Aseprite** a archivos **MP4** usando **FFmpeg**.

---

## 📦 Archivos incluidos

- `gif_to_mp4.lua` → Script principal para Aseprite.  
- `leeme.txt` → Archivo de ayuda con instrucciones adicionales (opcional).  

---

## ⚙️ Requisitos

1. **Aseprite** instalado. Versión utilizada 1.3.15.2
2. **FFmpeg** instalado en tu sistema.  
   - Puedes descargarlo desde [https://ffmpeg.org/download.html](https://ffmpeg.org/download.html).  
   - El script te pedirá la ruta del ejecutable `ffmpeg.exe` la primera vez.  
   - La ruta se guarda automáticamente para futuras conversiones.

---

## 🛠️ Instalación

1. Descarga o clona este repositorio.  
2. Copia la carpeta del proyecto (con `GIFtoMP4.lua` y `leeme.txt`) dentro de la carpeta `Scripts` de Aseprite:  
C:\Users<tu_usuario>\AppData\Roaming\Aseprite\Scripts\GIFtoMP4

---

## 🚀 Uso

1. Abre **Aseprite** y carga tu animación GIF.  
2. Ejecuta el script `GIFtoMP4.lua` desde **Archivo → Scripts → Ejecutar script**.  
3. Aparecerá un diálogo con estas opciones:

- **Ruta FFmpeg:** Ruta al ejecutable `ffmpeg.exe`.  
- **Calidad:** Alta / Media / Baja. Ajusta el tamaño del archivo y la calidad.  
- **Resolución:** Original / 720p / 1080p.  
- **Guardar como:** Ruta y nombre del archivo MP4 final.  

4. Pulsa **Convertir** y espera a que finalice.  
5. Pulsa **Ayuda** para ver el contenido de `leeme.txt`.  
6. Pulsa **Cancelar** para cerrar el diálogo.

---

## ✅ Características

- Conversión directa de GIF a MP4 usando **FFmpeg**.  
- Soporta resolución y calidad personalizable.

---

## ✨ Creado por

Emsdek + ChatGPT

