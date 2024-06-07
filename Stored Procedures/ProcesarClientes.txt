USE [FactPostPago]
GO
/****** Object:  StoredProcedure [dbo].[ProcesarClientes]    Script Date: 6/6/2024 23:24:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ProcesarClientes]
	-- Add the parameters for the stored procedure here
	@FechaOperacion DATE
AS
BEGIN

		SET NOCOUNT ON;
	BEGIN TRY
		DECLARE @doc XML;
		DECLARE @Contador INT;
		DECLARE @LargoClientes INT;
		DECLARE @LargoContratos INT;
		DECLARE @LargoRelaciones INT;
		DECLARE @IdClienteActual INT;
		DECLARE @IdClienteActual2 INT;


		SELECT @doc = BulkColumn
		FROM OPENROWSET(
			BULK 'C:\operacionesMasivas.xml', SINGLE_CLOB
		) AS Data;

		DECLARE @TempCliente TABLE(
			Id INT IDENTITY(1,1)
			, NumeroIdentificacion INT
			, Nombre VARCHAR(64)
			, Insertar INT
		)

		

		SET @Contador = 1;

		--Insercion de los clientes nuevos del dia en tabla temporal para hacer validaciones

		INSERT INTO @TempCliente(NumeroIdentificacion, Nombre, Insertar)
		SELECT Datos.value('@Identificacion', 'INT') AS Identificacion
			 , Datos.value('@Nombre', 'VARCHAR(64)') AS Nombre
			 , 1 AS Insertar
		FROM @doc.nodes('/Operaciones/FechaOperacion') AS T2(Datos1)
		CROSS APPLY Datos1.nodes('ClienteNuevo') AS T(Datos)
		WHERE Datos1.value('@fecha', 'DATE') = @FechaOperacion

		SELECT @LargoClientes = COUNT(*) FROM @TempCliente

		WHILE @Contador <= @LargoClientes
		BEGIN
			-- Verifica que el cliente no exista
			IF EXISTS (SELECT 1 FROM Clientes AS C INNER JOIN @TempCliente AS TC ON C.NumeroIdentificacion = TC.NumeroIdentificacion WHERE TC.Id = @Contador)
			BEGIN 
				UPDATE @TempCliente
				SET Insertar = 0
				WHERE Id = @Contador
			END
			SET @Contador = @Contador + 1 
		END
		/*
		--Insercion de los contratos nuevos del dia en tabla temporal para hacer validaciones

		INSERT INTO @TempContrato(Numero, DocIdCliente, IdTipoTarifa, Insertar)
		SELECT Datos.value('@Numero','BIGINT') AS Numero
			 , Datos.value('@DocIdCliente','INT') AS DocIdCliente
			 , Datos.value('@TipoTarifa', 'INT') AS TipoTarifa
			 , 1 AS Insertar
		FROM @doc.nodes('/Operaciones/FechaOperacion') AS T2(Datos1)
		CROSS APPLY Datos1.nodes('NuevoContrato') AS T(Datos)
		WHERE Datos1.value('@fecha', 'DATE') = @FechaOperacion

		SET @Contador = 1
		
		SELECT @LargoContratos = COUNT(*) FROM @TempContrato
		
		WHILE @Contador <= @LargoContratos
		BEGIN
		
		
			ESTO ESTA MAL, TENGO QUE HACER UN TRIGGER PARA QUE INSERTE CONTRATOS Y RELACIONES DESPUES DE INSERTAR LOS CLIENTES
		
		
			-- Verifica que el doc id del cliente exista en los clientes nuevos, cambiar el docId por el id del cliente y que el tipo tarifa exista
			IF NOT EXISTS (SELECT 1 FROM @TempCliente AS TC INNER JOIN @TempContrato AS TCO ON TCO.DocIdCliente = TC.NumeroIdentificacion WHERE TCO.Id = @Contador)
			BEGIN
				UPDATE @TempContrato
				SET Insertar = 0
				WHERE Id = @Contador
			END
			ELSE
			BEGIN
				SELECT @IdClienteActual = TC.Id FROM @TempCliente AS TC INNER JOIN @TempContrato AS TCO ON TCO.DocIdCliente = TC.NumeroIdentificacion WHERE TCO.Id = @Contador
				UPDATE @TempContrato
				SET DocIdCliente = @IdClienteActual
				WHERE Id = @Contador 
			END
		
			IF NOT EXISTS (SELECT 1 FROM @TempContrato AS TC INNER JOIN TipoTarifa AS TT ON TT.Id = TC.IdTipoTarifa WHERE TC.Id = @Contador)
			BEGIN
				UPDATE @TempContrato
				SET Insertar = 0
				WHERE Id = @Contador
			END
			SET @Contador = @Contador + 1 
		END

		--Insercion de las relaciones familiares nuevas del dia en tabla temporal para hacer validaciones

		INSERT INTO @TempRelacionFamiliar(DocIdDe, DocIdA, TipoRelacion, Insertar)
		SELECT Datos.value('@DocIdDe','INT') AS DocIdDe
			 , Datos.value('@DocIdA','INT') AS DocIdA
			 , Datos.value('@TipoRelacion', 'INT') AS TipoRelacion
			 , 1
		FROM @doc.nodes('/Operaciones/FechaOperacion') AS T2(Datos1)
		CROSS APPLY Datos1.nodes('RelacionFamiliar') AS T(Datos)
		WHERE Datos1.value('@fecha', 'DATE') = @FechaOperacion

		SET @Contador = 1

		SELECT @LargoRelaciones = COUNT(*) FROM @TempRelacionFamiliar
		
		WHILE @Contador <= @LargoRelaciones
		BEGIN
			-- Verificar que ambos DocId de los clientes existan, cambiar el docId de ambos por el id de cliente y verificar que el tipo de relacion exista
			IF NOT EXISTS (SELECT 1 FROM @TempCliente AS TC INNER JOIN @TempRelacionFamiliar AS TCO ON TCO.DocIdDe = TC.NumeroIdentificacion WHERE TCO.Id = @Contador)
			BEGIN
				UPDATE @TempRelacionFamiliar
				SET Insertar = 0
				WHERE Id = @Contador
			END
			ELSE
			BEGIN
				SELECT @IdClienteActual = TC.Id FROM @TempCliente AS TC INNER JOIN @TempRelacionFamiliar AS TCO ON TCO.DocIdDe = TC.NumeroIdentificacion WHERE TCO.Id = @Contador
				UPDATE @TempRelacionFamiliar
				SET DocIdDe = @IdClienteActual
				WHERE Id = @Contador 
			END
			
			IF NOT EXISTS (SELECT 1 FROM @TempCliente AS TC INNER JOIN @TempRelacionFamiliar AS TCO ON TCO.DocIdA = TC.NumeroIdentificacion WHERE TCO.Id = @Contador)
			BEGIN
				UPDATE @TempRelacionFamiliar
				SET Insertar = 0
				WHERE Id = @Contador
			END
			ELSE
			BEGIN
				SELECT @IdClienteActual2 = TC.Id FROM @TempCliente AS TC INNER JOIN @TempRelacionFamiliar AS TCO ON TCO.DocIdA = TC.NumeroIdentificacion WHERE TCO.Id = @Contador
				UPDATE @TempRelacionFamiliar
				SET DocIdA = @IdClienteActual2
				WHERE Id = @Contador 
			END

			IF NOT EXISTS (SELECT 1 FROM @TempRelacionFamiliar AS TC INNER JOIN TipoRelacionFamiliar AS TT ON TT.Id = TC.TipoRelacion WHERE TC.Id = @Contador)
			BEGIN
				UPDATE @TempContrato
				SET Insertar = 0
				WHERE Id = @Contador
			END

			SET @Contador = @Contador + 1 
		END
		*/

		BEGIN TRANSACTION
		
			INSERT INTO Clientes(NumeroIdentificacion, Nombre)
			SELECT TC.NumeroIdentificacion
				, TC.Nombre
			FROM @TempCliente AS TC
			WHERE TC.Insertar = 1

			/*INSERT INTO Contrato(IdCliente, IdTipoTarifa, Numero)
			SELECT TC.DocIdCliente
				, TC.IdTipoTarifa
				, TC.Numero
			FROM @TempContrato AS TC
			WHERE TC.Insertar = 1

			INSERT INTO RelacionFamiliar(IdCliente1, IdCliente2, IdTipoRelacionFamiliar)
			SELECT TR.DocIdDe
				, TR.DocIdA
				, TR.TipoRelacion
			FROM @TempRelacionFamiliar AS TR
			WHERE TR.Insertar = 1*/
		COMMIT TRANSACTION

	END TRY 
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION
	END CATCH
END
