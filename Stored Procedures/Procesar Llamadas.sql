USE [SistemaFacturacion]
GO
/****** Object:  StoredProcedure [dbo].[ProcesarLlamadas]    Script Date: 11/6/2024 20:04:05 ******/
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

        DECLARE @LlamadasEntrantes TABLE (
            Id INT IDENTITY(1,1),
            NumeroDe BIGINT,
            NumeroA BIGINT,
            FechaInicio DATETIME,
            FechaFin DATETIME 
        );

        SELECT @doc = BulkColumn
        FROM OPENROWSET(
            BULK 'C:\Users\sebas\Desktop\Bases de Datos I\Tarea Programada #3\operacionesMasivas.xml', SINGLE_CLOB
        ) AS Data;

        -- Insertar datos desde XML a tabla temporal
        INSERT INTO @LlamadasEntrantes (NumeroDe, NumeroA, FechaInicio, FechaFin)
        SELECT
            Datos.value('@NumeroDe', 'BIGINT') AS NumeroDe,
            Datos.value('@NumeroA', 'BIGINT') AS NumeroA,
            Datos.value('@Inicio', 'DATETIME') AS FechaInicio,
            Datos.value('@Final', 'DATETIME') AS FechaFin
        FROM @doc.nodes('/Operaciones/LlamadaTelefonica') AS T(Datos);

        -- Insertar datos desde tabla temporal a tabla permanente (Llamada)
        BEGIN TRANSACTION;
            INSERT INTO Llamada (NumeroDe, NumeroA, FechaInicio, FechaFin)
            SELECT NumeroDe, NumeroA, FechaInicio, FechaFin
            FROM @LlamadasEntrantes;
        COMMIT TRANSACTION;
    END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

	END CATCH

	SET NOCOUNT OFF;
END