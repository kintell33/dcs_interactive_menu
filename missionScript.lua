net.log("Mission Editor Public Function Script Loading...")

-- Inicializar el flag "units_count" directamente al cargar la misión si es posible
if trigger and trigger.misc and trigger.misc.setUserFlag then
    trigger.misc.setUserFlag("units_count", 0)
    net.log("Initialized units_count flag to 0")
else
    net.log("Error: trigger.misc.setUserFlag is not available in this context")
end

-- Función para registrar la cantidad de unidades cada 10 segundos
local function logUnitsCount()
    if trigger and trigger.misc and trigger.misc.getUserFlag then
        -- Obtener el valor del flag "units_count"
        local unitsCount = trigger.misc.getUserFlag("units_count")
        
        -- Mensaje con la cantidad de unidades
        local message = "Units red: " .. unitsCount
        trigger.action.outText(message, 10)
        net.log(message)
    else
        net.log("Error: trigger.misc.getUserFlag is not available in this context")
    end

    -- Reprogramar la función para que se ejecute cada 10 segundos
    mist.scheduleFunction(logUnitsCount, {}, timer.getTime() + 10)
end

-- Ejecutar la función por primera vez cuando se carga la misión después de 10 segundos
mist.scheduleFunction(logUnitsCount, {}, timer.getTime() + 10)

net.log("Mission Editor Public Function Script Loaded Successfully...")
