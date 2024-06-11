CREATE TRIGGER trg_InsertTipoTarifa
ON TipoTarifa
AFTER INSERT
AS
BEGIN
    -- Insertar los elementos fijos en la tabla de asociación
    INSERT INTO dbo.TipoTarifaXElementoTipoTarifa(idTipoTarifa, idElementoTipoTarifa, Valor)
    SELECT 
        i.id AS idTipoTarifa,
        e.id AS idElementoTipoTarifa,
        e.Valor
    FROM 
        Inserted i
    CROSS JOIN 
        dbo.ElementoTipoTarifa e
    WHERE 
        e.EsFijo = 1;
END;