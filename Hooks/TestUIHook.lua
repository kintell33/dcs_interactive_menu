net.log("Custom Hook Loading...")

local DialogLoader = require('DialogLoader')
local dxgui = require('dxgui')
local net = require('net')
local Input = require('Input')
local lfs = require('lfs')
local Tools = require('tools')
local U = require("me_utilities")
local Skin = require("Skin")

local dialog = nil
local secondaryDialog = nil
local dialogPath = lfs.writedir() .. 'Scripts/TestUIDialog.dlg'
local secondaryDialogPath = lfs.writedir() .. 'Scripts/TestUIDialogHotKey.dlg'
local config = nil
local defaultHotkey = "Ctrl+Shift+X"
local visibilityStatus = false  -- Variable para rastrear el estado de visibilidad

local dialogSkinHidden = Skin.windowSkinChatMin()

-- Guardar la configuración en archivo
local function saveConfiguration()
    local configPath = lfs.writedir() .. "Config/MenuBuyConfig.lua"
    U.saveInFile(config, "config", configPath)
end

-- Cargar la configuración desde archivo
local function loadConfiguration()
    net.log("Loading config file...")
    local configPath = lfs.writedir() .. "Config/MenuBuyConfig.lua"
    local tbl = Tools.safeDoFile(configPath, false)
    if (tbl and tbl.config) then
        net.log("Configuration exists...")
        config = tbl.config
    else
        net.log("Configuration not found, creating defaults...")
        config = {
            hotkey = defaultHotkey
        }
        saveConfiguration()
    end
end

local function triggerBuyAircraftEvent()
    net.log("Aircraft bought event triggered")
    
    local flagName = "units_count"

    local setCommand = [[
        local currentCount = trigger.misc.getUserFlag("]] .. flagName .. [[")
        trigger.misc.setUserFlag("]] .. flagName .. [[", currentCount + 1)
    ]]
    
    local status, error = net.dostring_in('server', setCommand)
    if not status then
        net.log("Error: Could not set flag value, " .. error)
    else
        net.log("Flag '" .. flagName .. "' incremented successfully.")
    end
end

local function buyAircraft()
    net.log("Buy aircraft triggered")
    triggerBuyAircraftEvent()
end

local function loadDialog()
    net.log("Loading Dialog from path: " .. dialogPath)
    
    if not lfs.attributes(dialogPath) then
        net.log("Error: Dialog file not found at path: " .. dialogPath)
        return
    end

    dialog = DialogLoader.spawnDialogFromFile(dialogPath)

    if dialog == nil then
        net.log("Error: Failed to load dialog from file")
        return
    end
    
    -- Asegurarse de que el diálogo esté dentro de la pantalla
    local screenWidth, screenHeight = dxgui.GetScreenSize()
    local x = math.floor(screenWidth / 2 - 150)  -- Centrar el diálogo en la pantalla
    local y = math.floor(screenHeight / 2 - 100)
    dialog:setBounds(x, y, 300, 200)

    dialog:setVisible(true)
    visibilityStatus = true  -- Actualizar el estado de visibilidad
    net.log("Dialog loaded successfully")

    if dialog.buyButton then
        dialog.buyButton.onChange = function()
            buyAircraft()
        end
    else
        net.log("Error: showButton not found in dialog")
    end
end

local function showDialog()
    net.log("Showing dialog...")
    loadDialog()
end


local function toggleDialogVisibility()
    net.log("Toggle dialog visibility...")
    showDialog()
end

local function handleHotkey()
    if config and config.hotkey then
        net.log("Setting hotkey callback for: " .. config.hotkey)
        if secondaryDialog then
            secondaryDialog:addHotKeyCallback(config.hotkey, function()
                toggleDialogVisibility()
            end)
        end
    end
end

local function loadSecondaryDialog()
    -- Crear un diálogo secundario vacío que siempre esté oculto, para manejar los hotkeys sin interferir con el diálogo principal
    net.log("Loading Secondary Dialog from path: " .. secondaryDialogPath)
    
    if not lfs.attributes(secondaryDialogPath) then
        net.log("Error: Secondary Dialog file not found at path: " .. secondaryDialogPath)
        return
    end

    secondaryDialog = DialogLoader.spawnDialogFromFile(secondaryDialogPath)

    -- local screenWidth, screenHeight = dxgui.GetScreenSize()
    -- local x = math.floor(screenWidth / 2 - 150)
    -- local y = math.floor(screenHeight / 2 - 100)
    -- secondaryDialog:setBounds(x, y, 300, 200)
    -- center dialog outside screen setBounds
    secondaryDialog:setBounds(-1000, -1000, 300, 200)

    --secondaryDialog:setSkin(dialogSkinHidden)
    secondaryDialog:setVisible(true)
    -- secondaryDialog:setHasCursor(false)

    handleHotkey()  -- Agregar la funcionalidad del hotkey al diálogo secundario
end



local function onMissionLoad()
    net.log("Mission loaded, showing Dialog...")
    loadSecondaryDialog()
    loadDialog()
end


-- Cargar la configuración y configurar el hook
loadConfiguration()

-- Conectar el hook a la carga de la misión y al inicio del juego
DCS.setUserCallbacks({
    onMissionLoadEnd = function()
        onMissionLoad()
    end,
})

net.log("Custom Hook Loaded UI...")