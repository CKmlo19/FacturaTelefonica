USE [SistemaFacturacion]
GO
/****** Object:  StoredProcedure [dbo].[ProcesarUsoDatos]    Script Date: 11/6/2024 20:04:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ProcesarUsoDatos]
	@FechaOperacion DATE
AS 
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @doc XML;
		DECLARE @CantidadGigasConsumidos INT;
		DECLARE @IdFactura INT;
		DECLARE @Contador INT;
		DECLARE @LargoDatos INT;
		DECLARE @FacturaActual INT;
		DECLARE @TelefonoActual BIGINT;
		DECLARE @CantidadGigas FLOAT;
		DECLARE @LimiteGigas FLOAT; 

		SELECT @doc = BulkColumn
		FROM OPENROWSET(
			BULK 'C:\Users\sebas\Desktop\Bases de Datos I\Tarea Programada #3\operacionesMasivas.xml', SINGLE_CLOB
		) AS Data;

		DECLARE @TempDatos TABLE(
			Id INT IDENTITY(1,1)
			, Numero BIGINT
			, Fecha DATE
			, IdFactura INT NULL
			, QGigas FLOAT
		)

		INSERT INTO @TempDatos(Numero, QGigas, IdFactura, Fecha)
		SELECT Datos.value('@Numero', 'INT') AS Numero
			 , Datos.value('@QGigas', 'VARCHAR(64)') AS QGigas
			 , NULL
			 , @FechaOperacion AS FechaOperacion
		FROM @doc.nodes('/Operaciones/FechaOperacion') AS T2(Datos1)
		CROSS APPLY Datos1.nodes('UsoDatos') AS T(Datos)
		WHERE Datos1.value('@fecha', 'DATE') = @FechaOperacion

		SET @Contador = 1

		SELECT @LargoDatos = COUNT(*) FROM @TempDatos

		WHILE @Contador <= @LargoDatos
		BEGIN
			--Introducir el FK de la factura en la tabla temporal
			SELECT @TelefonoActual =  Numero FROM @TempDatos WHERE Id = @Contador
			SELECT @FacturaActual = (SELECT TOP 1 F.Id 
			FROM Factura AS F INNER JOIN Contrato AS C ON C.Id = F.IdContrato
			WHERE C.Numero = @TelefonoActual 
			ORDER BY F.Id DESC)

			UPDATE @TempDatos
			SET IdFactura = @FacturaActual
			WHERE Id = @Contador
			SET @Contador = @Contador + 1
		END

		BEGIN TRANSACTION
			INSERT INTO UsoDatos(IdFactura
				, Numero
				, QGigas
				, Fecha)
			SELECT IdFactura
				, Numero
				, QGigas
				, Fecha
			FROM @TempDatos
		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION
	
	END CATCH

	SET NOCOUNT OFF;

END