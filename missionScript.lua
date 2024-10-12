net.log("Buy Aircraft Event Script Loading...")

-- Asegurarse de que missionCommands sea global
missionCommands = missionCommands or {}

-- Definir la función de compra de aeronave en la tabla global
function missionCommands.onBuyAircraftEvent()
    net.log("Aircraft bought event triggered 1")
    trigger.action.outText("Aircraft bought", 10)  -- Mostrar el mensaje durante 10 segundos a todos los jugadores
    net.log("Aircraft bought event triggered 2")
end

net.log("Buy Aircraft Event Script Loaded...")

-- Ejecutar la función directamente para probarla
missionCommands.onBuyAircraftEvent()
