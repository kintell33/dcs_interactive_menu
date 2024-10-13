local function mensajeUnidades()
    if trigger ~= nil and trigger.misc ~= nil and trigger.action ~= nil then
        -- Obtener el valor del flag 'units_count' a nivel servidor
        local contador = trigger.misc.getUserFlag("units_count")

        -- Mensaje en pantalla
        trigger.action.outText("Unidades disponibles: " .. contador, 5)

        -- Llama a esta función de nuevo en 10 segundos
        timer.scheduleFunction(mensajeUnidades, {}, timer.getTime() + 10)
    else
        env.info("Trigger no está disponible")
    end
end

-- Iniciar la primera llamada después de 10 segundos
mensajeUnidades()