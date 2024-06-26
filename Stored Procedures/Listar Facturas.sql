USE [SistemaFacturacion]
GO
/****** Object:  StoredProcedure [dbo].[ListarFacturas]    Script Date: 11/6/2024 20:08:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ListarFacturas](
	@inNumeroTelefono VARCHAR(64),
	@OutResultCode INT OUTPUT
)
AS
BEGIN
	BEGIN TRY
		SET @OutResultCode = 0
		SET NOCOUNT ON;

		SELECT 
        f.Id AS FacturaId,
        f.IdContrato,
        f.IdEstado,
        e.Nombre AS Estado,
        f.FechaEmision,
        f.TotalAPagar,
        df.TotalConIVA,
        df.TotalSinIVA,
        df.MultaPorAtraso,
        df.FechaPago AS DetalleFechaPago,
        de.TarifaBasica,
        de.QMinutosExceso,
        de.QGigasExceso,
        de.QFamiliar,
        de.QNocturnos,
        de.Llamada911,
        de.Llamada110,
        de.Llamada900,
        de.Llamada800
    FROM 
        dbo.Factura f
    INNER JOIN 
        dbo.Contrato c ON f.IdContrato = c.Id
    INNER JOIN 
        dbo.EstadoFactura e ON f.IdEstado = e.Id
    LEFT JOIN 
        DetalleFactura df ON f.Id = df.IdFactura
    LEFT JOIN 
        DetalleElementosCobro De ON df.Id = de.IdDetalleFactura
	WHERE C.Numero = @inNumeroTelefono
	ORDER BY f.FechaEmision DESC;  -- Ordenar de las más viejas a las más nuevas
	END TRY
	BEGIN CATCH
		INSERT INTO dbo.DBError	VALUES (
				SUSER_SNAME(),
				ERROR_NUMBER(),
				ERROR_STATE(),
				ERROR_SEVERITY(),
				ERROR_LINE(),
				ERROR_PROCEDURE(),
				ERROR_MESSAGE(),
				GETDATE()
			);

			SET @OutResulTCode=50008  ;
	END CATCH
END;