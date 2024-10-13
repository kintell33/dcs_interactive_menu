net.log("Custom Hook Loading...")

local DialogLoader = require('DialogLoader')
local dxgui = require('dxgui')
local net = require('net')
local Input = require('Input')
local lfs = require('lfs')
local Tools = require('tools')
local U = require("me_utilities")

local dialog = nil
local dialogPath = lfs.writedir() .. 'Scripts\\TestUIDialog.dlg'
local config = nil
local defaultHotkey = "Ctrl+Shift+X"

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
    trigger.action.outText("Aircraft bought", 10)  -- Mostrar el mensaje durante 10 segundos a todos los jugadores
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
    net.log("Dialog loaded successfully")

    if dialog.showButton then
        dialog.showButton:setText("Comprar")
        dialog.showButton:setSkin({
            params = {
                name = "buttonSkin"
            },
            states = {
                released = {
                    [1] = {
                        bkg = {
                            center_center = "0x808080ff"  -- Color de fondo gris con opacidad completa
                        },
                        text = {
                            color = "0xffffffff",  -- Texto blanco
                            font = "Arial",
                            lineHeight = 10
                        }
                    }
                }
            }
        })
        dialog.showButton.onChange = function()
            buyAircraft()
        end
    else
        net.log("Error: showButton not found in dialog")
    end
end

local function handleHotkey()
    if config and config.hotkey then
        net.log("Setting hotkey callback for: " .. config.hotkey)
        if dialog then
            dialog:addHotKeyCallback(config.hotkey, function()
                net.log("Key pressed: " .. tostring(keyName))
                if dialog:getVisible() then
                    dialog:setVisible(false)
                else
                    dialog:setVisible(true)
                end
            end)
        else
            net.log("Dialog not loaded yet, cannot set hotkey callback")
        end
    end
end

local function onMissionLoad()
    net.log("Mission loaded, showing Dialog...")
    loadDialog()
    handleHotkey()
end

local function toggleDialogVisibility()
    net.log("Toggle dialog visibility...")
    if dialog then
        if dialog:getVisible() then
            dialog:setVisible(false)
        else
            dialog:setVisible(true)
        end
    else
        loadDialog()  -- Si no está cargado, lo cargamos nuevamente
    end
end

local function handleHotkey()
    if config and config.hotkey then
        net.log("Setting hotkey callback for: " .. config.hotkey)
        if dialog then
            dialog:addHotKeyCallback(config.hotkey, function()
                net.log("Key pressed: " .. tostring(keyName))
                if dialog:getVisible() then
                    dialog:setVisible(false)
                else
                    dialog:setVisible(true)
                end
            end)
        else
            net.log("Dialog not loaded yet, cannot set hotkey callback")
        end
    end
end

-- Cargar la configuración y configurar el hook
loadConfiguration()
handleHotkey()

-- Conectar el hook a la carga de la misión
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