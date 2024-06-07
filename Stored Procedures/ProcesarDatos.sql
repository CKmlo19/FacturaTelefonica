USE [FactPostPago]
GO
/****** Object:  StoredProcedure [dbo].[ProcesarDatos]    Script Date: 6/6/2024 23:24:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ProcesarDatos]
	-- Add the parameters for the stored procedure here
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
			BULK 'C:\operacionesMasivas.xml', SINGLE_CLOB
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
			FROM Facturas AS F INNER JOIN Contrato AS C ON C.Id = F.IdContrato
			WHERE C.Numero = @TelefonoActual 
			ORDER BY F.Id DESC)

			UPDATE @TempDatos
			SET IdFactura = @FacturaActual
			WHERE Id = @Contador

			--Revisar si no se han excedido los megas (Podria hacerlo cuando se vaya a generar la factura)
			/*SELECT @CantidadGigasConsumidos =  COALESCE(SUM(U.QGigas), 0) FROM UsoDatos AS U

			SELECT @LimiteGigas = TTxTE.Valor 
			FROM Contrato AS C 
			INNER JOIN TipoTarifaXTipoElemento AS TTxTE ON TTxTE.IdTipoTarifa = C.IdTipoTarifa 
			WHERE C.Numero = @TelefonoActual AND TTxTE.IdTipoElemento = 5

			SELECT @CantidadGigas = T.QGigas FROM @TempDatos AS T WHERE T.Id = @Contador

			--Si se excede los limites de gigas añade la cantidad de gigas extra a su detalle de factura
			IF ((@CantidadGigasConsumidos + @CantidadGigas) - @LimiteGigas) < 0
			BEGIN
				SET @Excedido = 1
			END*/
			SET @Contador = @Contador + 1
		END

		BEGIN TRANSACTION
			INSERT INTO UsoDatos(IdFactura
				, Numero
				, Fecha
				, QGigas)
			SELECT IdFactura
				, Numero
				, Fecha
				, QGigas
			FROM @TempDatos
		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 1
			ROLLBACK TRANSACTION
	END CATCH
END
