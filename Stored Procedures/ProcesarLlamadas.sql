USE [FactPostPago]
GO
/****** Object:  StoredProcedure [dbo].[ProcesarLlamadas]    Script Date: 6/6/2024 23:25:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ProcesarLlamadas]

	@FechaOperacion DATE
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @doc XML;

		DECLARE @LlamadasEntrantes TABLE(
			Id INT IDENTITY(1,1)
			, NumeroDe BIGINT
			, NumeroA BIGINT
			, FechaInicio DATETIME
			, FechaFin DATETIME 
		)

		SELECT @doc = BulkColumn
		FROM OPENROWSET(
			BULK 'C:\operacionesMasivas.xml', SINGLE_CLOB
		) AS Data;

		INSERT INTO @LlamadasEntrantes(NumeroDe
			, NumeroA
			, FechaInicio
			, FechaFin)
		SELECT Datos.value('@NumeroDe', 'BIGINT') AS NumeroDe
			 , Datos.value('@NumeroA', 'BIGINT') AS NumeroA
			 , Datos.value('@Inicio', 'DATETIME') AS FechaInicio
			 , Datos.value('@Final', 'DATETIME') AS FechaFin
		FROM @doc.nodes('/Operaciones/FechaOperacion') AS T2(Datos1)
		CROSS APPLY Datos1.nodes('LlamadaTelefonica') AS T(Datos)
		WHERE Datos1.value('@fecha', 'DATE') = @FechaOperacion

		BEGIN TRANSACTION
			INSERT INTO Llamada(NumeroDe
				, NumeroA
				, FechaInicio
				, FechaFin)
			SELECT NumeroDe
				, NumeroA
				, FechaInicio
				, FechaFin
			FROM @LlamadasEntrantes
		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION
	END CATCH

	
END
