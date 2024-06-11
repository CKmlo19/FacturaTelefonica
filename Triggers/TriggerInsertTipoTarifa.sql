CREATE TRIGGER trg_InsertTipoTarifa
ON TipoTarifa
AFTER INSERT
AS
BEGIN
    -- Insertar los elementos fijos en la tabla de asociaci�n
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