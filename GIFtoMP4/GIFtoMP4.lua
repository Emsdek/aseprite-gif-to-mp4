-- GIF to MP4 Converter V1.0 para Aseprite
-- David + ChatGPT 2025

local sprite = app.activeSprite

-- Mostrar alertas
local function showAlert(title, message)
    app.alert{ title=title, text=message, buttons="OK" }
end

-- Comillas para rutas
local function quote(path)
    return '"' .. path .. '"'
end

-- --- Persistencia simple de la ruta de FFmpeg --- --
local function _configFilePath()
    local base = app.fs.userConfigPath or app.fs.tempPath
    return app.fs.joinPath(base, "gif2mp4_ffmpeg_path.txt")
end

local function loadFFmpegPath()
    local cfg = _configFilePath()
    local f = io.open(cfg, "r")
    if not f then return "" end
    local p = f:read("*l") or ""
    f:close()
    if p ~= "" and app.fs.isFile(p) then return p end
    return ""
end

local function saveFFmpegPath(path)
    local cfg = _configFilePath()
    local f = io.open(cfg, "w")
    if f then f:write(path or ""); f:close() end
end

-- Crear GIF temporal
local function exportTempGIF(sprite, tempPath)
    sprite:saveCopyAs(tempPath)
end

-- Ejecutar conversión usando .bat temporal
local function convertToMP4(gifPath, outputPath, ffmpegPath, quality, resolution)
    local command = quote(ffmpegPath) .. " -i " .. quote(gifPath)

    -- Resolución
    if resolution == "original" then
        command = command .. " -vf \"scale=trunc(iw/2)*2:trunc(ih/2)*2\""
    elseif resolution == "720p" then
        command = command .. " -vf scale=-2:720"
    elseif resolution == "1080p" then
        command = command .. " -vf scale=-2:1080"
    end

    -- Calidad
    local crf = 23
    if quality == "alta" then crf = 18
    elseif quality == "baja" then crf = 30 end

    command = command .. " -c:v libx264 -pix_fmt yuv420p -crf " .. crf ..
        " -preset medium -movflags +faststart -y " .. quote(outputPath)

    -- Archivos temporales
    local tempDir    = app.fs.tempPath
    local commandTxt = app.fs.joinPath(tempDir, "ffmpeg_command.txt")
    local logPath    = app.fs.joinPath(tempDir, "ffmpeg_log.txt")
    local batPath    = app.fs.joinPath(tempDir, "ffmpeg_run.bat")

    -- Guardar comando en txt
    local f = io.open(commandTxt, "w")
    if f then f:write(command); f:close() end

    -- Crear .bat
    local b = io.open(batPath, "w")
    if b then
        b:write("@echo off\n")
        b:write(command .. " > " .. quote(logPath) .. " 2>&1\n")
        b:close()
    end

    -- Ejecutar .bat
    os.execute('cmd /c ' .. quote(batPath))

    local success = app.fs.isFile(outputPath)
    if success then os.remove(batPath) end
    return success
end

-- Mostrar ayuda con Dialog seguro (líneas separadas)
local function showHelp()
    local src = debug.getinfo(1, "S").source or ""
    local scriptPath = src:match("^@(.+)$") or ""
    local scriptDir = app.fs.filePath(scriptPath) or ""
    local leemePath = app.fs.joinPath(scriptDir, "leeme.txt")

    if app.fs.isFile(leemePath) then
        local f = io.open(leemePath, "r")
        local content = f and f:read("*a") or ""
        if f then f:close() end
        content = content ~= "" and content or "El archivo leeme.txt está vacío."
        content = content:gsub("\r\n","\n")

        local dlg = Dialog("Ayuda - leeme.txt")
        for line in content:gmatch("[^\n]+") do
            dlg:label{label=line}
        end

        dlg:button{id="close", text="Cerrar", onclick=function() dlg:close() end}
        dlg:show{wait=false}
    else
        showAlert("Ayuda", "No se encontró leeme.txt en: " .. leemePath)
    end
end

-- Principal
local function main()
    if not sprite then
        showAlert("Error", "No hay ningún sprite abierto. Abre un archivo de Aseprite primero.")
        return
    end

    if #sprite.frames <= 1 then
        showAlert("Error", "El sprite debe tener al menos 2 frames para crear una animación.")
        return
    end

    local last_ffmpeg = loadFFmpegPath()
    local dlg = Dialog("GIF to MP4 Converter")

    dlg:file{
        id="ffmpeg_path",
        label="Ruta FFmpeg:",
        title="Selecciona ffmpeg.exe",
        open=true,
        filetypes={"exe"},
        filename=last_ffmpeg
    }

    dlg:combobox{id="quality", label="Calidad:", option="media", options={"alta","media","baja"}}
    dlg:combobox{id="resolution", label="Resolución:", option="original", options={"original","720p","1080p"}}

    dlg:file{id="output_path", label="Guardar como:", title="Guardar MP4", save=true, filename="animation.mp4", filetypes={"mp4"}}

    dlg:button{
        id="convert",
        text="Convertir",
        onclick=function()
            local data = dlg.data
            if not data.output_path or data.output_path == "" then
                showAlert("Error", "Especifica dónde guardar el archivo MP4."); return
            end
            if not data.ffmpeg_path or not app.fs.isFile(data.ffmpeg_path) then
                showAlert("Error", "No se encontró FFmpeg en la ruta especificada."); return
            end

            saveFFmpegPath(data.ffmpeg_path)
            local tempPath = app.fs.joinPath(app.fs.tempPath,"aseprite_temp.gif")
            sprite:saveCopyAs(tempPath)

            showAlert("Información","Convirtiendo a MP4... Esto puede tomar unos momentos.")
            local success = convertToMP4(tempPath, data.output_path, data.ffmpeg_path, data.quality, data.resolution)
            os.remove(tempPath)

            if success then
                showAlert("Éxito", "¡Conversión completada! ✅ Archivo MP4: "..data.output_path)
            else
                showAlert("Error", "La conversión falló ❌ Revisa los archivos en la carpeta TEMP.")
            end
        end
    }

    dlg:button{id="help", text="Ayuda", onclick=function() showHelp() end}
    dlg:button{id="cancel", text="Cancelar", onclick=function() dlg:close() end}

    dlg:show{wait=false}
end

main()
