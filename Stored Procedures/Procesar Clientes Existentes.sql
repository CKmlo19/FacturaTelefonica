USE [SistemaFacturacion]
GO
/****** Object:  StoredProcedure [dbo].[ProcesarClientesExistentes]    Script Date: 11/6/2024 20:04:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ProcesarClientesExistentes]
	@FechaOperacion DATE
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY 
		
		DECLARE @Contador INT;
		DECLARE @LargoFacturasVencen INT;
		DECLARE @FechaPrimerContrato DATE;
		DECLARE @IdContratoActual INT;
		DECLARE @FechaPagoActual DATE;
		DECLARE @Aux VARCHAR(16);

		DECLARE @FacturasQueVencenHoy TABLE(
			Id INT IDENTITY(1,1)
			, IdContrato INT
			, IdEstado INT
			, FechaEmision DATE
			, FechaPago DATE
			, TotalAPagar FLOAT
		)

		INSERT INTO @FacturasQueVencenHoy
		SELECT F.IdContrato
			, 1
			, @FechaOperacion
			, CAST(DATEADD(MONTH, 1, @FechaOperacion) AS DATE)
			, 0
		FROM Factura AS F
		WHERE F.FechaPago = @FechaOperacion

		SET @Contador = 1
		SELECT @LargoFacturasVencen = COUNT(*) FROM @FacturasQueVencenHoy

		WHILE @Contador <= @LargoFacturasVencen
		BEGIN

		--Verificar si es 28/29 febrero, o verificar si es 30/31 de cualquier otro mes

			IF(DAY(@FechaOperacion) = 28 AND MONTH(@FechaOperacion) = 2) OR (DAY(@FechaOperacion) = 29 AND MONTH(@FechaOperacion) = 2) OR DAY(@FechaOperacion) = 30
			BEGIN 
				SELECT @IdContratoActual = FV.IdContrato FROM @FacturasQueVencenHoy AS FV WHERE FV.Id = @Contador
				SELECT @FechaPrimerContrato = (SELECT TOP 1 F.FechaEmision FROM Factura AS F WHERE F.IdContrato = @IdContratoActual)

				IF DAY(@FechaPrimerContrato) != DAY(@FechaOperacion)
				BEGIN
					SELECT @FechaPagoActual = FV.FechaPago FROM @FacturasQueVencenHoy AS FV WHERE FV.Id = @Contador
					SET @Aux = CAST(YEAR(@FechaPagoActual) AS VARCHAR) + '-' + CAST(MONTH(@FechaPagoActual) AS VARCHAR) + '-' + CAST(DAY(@FechaPrimerContrato) AS VARCHAR)
					UPDATE @FacturasQueVencenHoy
					SET FechaPago = CAST(@Aux AS DATE)
					WHERE Id = @Contador
				END
			END

			SET @Contador = @Contador + 1
		END
		
		BEGIN TRANSACTION
			INSERT INTO Factura(IdContrato
				, IdEstado
				, FechaEmision
				, FechaPago
				, TotalAPagar)
			SELECT IdContrato
				, IdEstado
				, FechaEmision
				, FechaPago
				, TotalAPagar
			FROM @FacturasQueVencenHoy
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

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

	END CATCH

	SET NOCOUNT OFF;
END