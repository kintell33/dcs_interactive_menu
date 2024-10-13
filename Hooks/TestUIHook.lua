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
local dialogPath = lfs.writedir() .. 'Scripts/TestUIDialog.dlg'
local config = nil
local defaultHotkey = "Ctrl+Shift+X"
local visibilityStatus = false  -- Variable para rastrear el estado de visibilidad

local dialogDefaultSkin = nil
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

-- Disparar el evento de comprar aeronave en el contexto del servidor
local function triggerBuyAircraftEvent()
    net.log("Aircraft bought event triggered")
end

local function buyAircraft()
    net.log("Buy aircraft triggered")
    triggerBuyAircraftEvent()
end


local function showDialog()
    if dialog == nil then
        local status, err = pcall(loadDialog)
        if not status then
            net.log("[Scratchpad] Error creating dialog: " .. tostring(err))
            return
        end
    end

    dialog:setVisible(true)
    dialog:setSkin(dialogDefaultSkin)
    dialog:setHasCursor(true)
    visibilityStatus = true
end

local function hideDialog()
    if dialog then
        -- No se puede simplemente ocultar el diálogo, ya que esto lo destruiría
        dialog:setSkin(dialogSkinHidden)
        dialog:setHasCursor(false)
        visibilityStatus = false
    end
end

local function toggleDialogVisibility()
    net.log("Toggle dialog visibility...")
    if visibilityStatus then
        hideDialog()
    else
        showDialog()
    end
end

local function handleHotkey()
    if config and config.hotkey then
        net.log("Setting hotkey callback for: " .. config.hotkey)
        Input.addHotKey(config.hotkey, function()
            net.log("Hotkey pressed: " .. config.hotkey)
            toggleDialogVisibility()
        end)
    end
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
    dialogDefaultSkin = dialog:getSkin()  -- Guardar el skin por defecto
    visibilityStatus = true  -- Actualizar el estado de visibilidad
    net.log("Dialog loaded successfully")

    if dialog.showButton then
        dialog.showButton:setText("Comprar")
        dialog.showButton.onChange = function()
            buyAircraft()
        end
    else
        net.log("Error: showButton not found in dialog")
    end

    handleHotkey()
end

local function onMissionLoad()
    net.log("Mission loaded, showing Dialog...")
    loadDialog()
end

local function onGameStart()
    net.log("Game started, showing Dialog...")
    loadDialog()
end

-- Cargar la configuración y configurar el hook
loadConfiguration()

-- Conectar el hook a la carga de la misión y al inicio del juego
DCS.setUserCallbacks({
    onMissionLoadEnd = function()
        onMissionLoad()
    end,
    onSimulationStop = function()
        if dialog then
            dialog:setVisible(false)
        end
    end
})

net.log("Custom Hook Loaded...")