net.log("Custom Hook Loading...")

local DialogLoader = require('DialogLoader')
local dxgui = require('dxgui')
local net = require('net')
local Input = require('Input')

local dialog = nil
local dialogPath = lfs.writedir() .. 'Scripts\\TestUIDialog.dlg'
local hotkeyCombination = "Ctrl+K+D"

-- Disparar el evento de comprar aeronave en el contexto del servidor
local function triggerBuyAircraftEvent()
    net.log("Triggering buy aircraft event...")
    -- Llama a la función 'missionCommands.onBuyAircraftEvent()' en el contexto de la misión
    net.dostring_in('mission', 'missionCommands.onBuyAircraftEvent()')
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
        dialog.showButton.onChange = function()
            buyAircraft()
        end
    else
        net.log("Error: showButton not found in dialog")
    end
end

local function onMissionLoad()
    net.log("Mission loaded, showing Dialog...")
    loadDialog()
end

local function toggleDialogVisibility()
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

-- Conectar el hook a la carga de la misión y agregar hotkey para el cuadro de diálogo
DCS.setUserCallbacks({
    onMissionLoadEnd = function()
        onMissionLoad()
    end,
    onSimulationStop = function()
        if dialog then
            dialog:setVisible(false)
        end
    end,
    onKeyDown = function(keyName, unicode)
        if Input.isKeyboardKeyPressed(hotkeyCombination) then
            toggleDialogVisibility()
        end
    end
})

net.log("Custom Hook Loaded...")
