USE [SistemaFacturacion]
GO
/****** Object:  StoredProcedure [dbo].[CargaOperacionesMasivas]    Script Date: 11/6/2024 20:06:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CargaOperacionesMasivas]

AS
BEGIN

	SET NOCOUNT ON;

    DECLARE @XMLDoc XML;
	DECLARE @Contador INT;
	DECLARE @CantidadDias INT;
	DECLARE @FechaActual DATE;
	DECLARE @FechasOperacion TABLE(
		Id INT IDENTITY(1,1)
		, FechaOperacion DATE
	)

	SET @Contador = 1;
	
	SELECT @XMLDoc = BulkColumn
	FROM OPENROWSET(
		BULK 'C:\Users\sebas\Desktop\Bases de Datos I\Tarea Programada #3\operacionesMasivas.xml', SINGLE_CLOB
	) AS x;

	--Ingresar las fechas de operacion

	INSERT INTO @FechasOperacion(FechaOperacion)
	SELECT Xml.value('@fecha','DATE') AS FechaOperacion
	FROM @XMLDoc.nodes('/Operaciones/FechaOperacion') AS T(Xml)

	SELECT @CantidadDias = COUNT(*) FROM @FechasOperacion 

	INSERT INTO FechaActual(FechaActual)
	SELECT FechaOperacion
	FROM @FechasOperacion AS F
	WHERE F.Id = 1

	--Ir por cada FechaOperacion hasta el final
	
	WHILE @Contador <= @CantidadDias
	BEGIN
		UPDATE FechaActual
		SET FechaActual = (SELECT F.FechaOperacion FROM @FechasOperacion AS F WHERE Id = @Contador)
		WHERE Id = 1
		SELECT @FechaActual = F.FechaActual FROM FechaActual AS F WHERE F.Id = 1
		
		--Procesar nuevos contratos, clientes y relaciones
		EXEC [dbo].[ProcesarNuevosClientes] @FechaActual
		--Procesar llamadas
		EXEC [dbo].[ProcesarLlamadas] @FechaActual 
		--Generar facturas nuevas de clientes existentes por vencimiento de factura
		EXEC [dbo].[ProcesarClientesExistentes] @FechaActual
		--Procesar datos
		EXEC [dbo].[ProcesarUsoDatos] @FechaActual

		SET @Contador = @Contador + 1
	END

	SET NOCOUNT OFF;

END