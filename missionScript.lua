net.log("Buy Aircraft Event Script Loading...")

-- Creamos una tabla global llamada missionCommands para almacenar eventos personalizados
missionCommands = missionCommands or {}

-- Definir la función de compra de aeronave
function missionCommands.onBuyAircraftEvent()
    trigger.action.outText("Aircraft bought", 10)  -- Mostrar el mensaje durante 10 segundos a todos los jugadores
    net.log("Aircraft bought event triggered")
end

net.log("Buy Aircraft Event Script Loaded...")
