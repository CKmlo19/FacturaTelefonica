USE [FactPostPago]
GO
/****** Object:  StoredProcedure [dbo].[CargaOperacionesMasivas]    Script Date: 6/6/2024 23:24:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CargaOperacionesMasivas]
	@OutResultCode INT OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

    DECLARE @doc XML;
	DECLARE @Contador INT;
	DECLARE @CantidadDias INT;
	DECLARE @FechaActual DATE;
	DECLARE @FechasOperacion TABLE(
		Id INT IDENTITY(1,1)
		, FechaOperacion DATE
	)

	SET @Contador = 1;
	
	SELECT @doc = BulkColumn
	FROM OPENROWSET(
		BULK 'C:\operacionesMasivas.xml', SINGLE_CLOB
	) AS Data;


	-- Se ingresan todas las fechas de operacion

	INSERT INTO @FechasOperacion(FechaOperacion)
	SELECT Datos.value('@fecha','DATE') AS FechaOperacion
	FROM @doc.nodes('/Operaciones/FechaOperacion') AS T(Datos)

	SELECT @CantidadDias = COUNT(*) FROM @FechasOperacion 

	INSERT INTO FechaActual(FechaActual)
	SELECT FechaOperacion
	FROM @FechasOperacion AS F 
	WHERE F.Id = 1

	--Se itera por cada FechaOperacion
	
	WHILE @Contador <= 2--@CantidadDias
	BEGIN
		
		UPDATE FechaActual
		SET FechaActual = (SELECT F.FechaOperacion FROM @FechasOperacion AS F WHERE Id = @Contador)
		WHERE Id = 1
		SELECT @FechaActual = F.FechaActual FROM FechaActual AS F WHERE F.Id = 1

		--Generar facturas nuevas de clientes existentes por vencimiento de factura
		EXEC [dbo].[ProcesarClientesExistentes] @FechaActual
		--Procesar nuevos contratos, clientes y relaciones
		EXEC [dbo].[ProcesarClientes] @FechaActual 
		--Procesar llamadas
		EXEC [dbo].[ProcesarLlamadas] @FechaActual 
		--Procesar datos
		EXEC [dbo].[ProcesarDatos] @FechaActual
		--Procesar pagos
		--EXEC [dbo].[ProcesarPagos] @FechaActual
		--Hacer corte de estado de cuenta los 5 de cada mes
		/*IF DAY(@FechaActual) = 5
		BEGIN
			--EXEC [dbo].[ProcesarEstadoCuenta] @FechaActual 
		END*/
		SET @Contador = @Contador + 1
	END

END
