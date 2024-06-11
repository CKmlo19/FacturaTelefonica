USE [FactPostPago]
GO
/****** Object:  StoredProcedure [dbo].[CargarConfig]    Script Date: 6/6/2024 23:24:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CargarConfig]
	-- Add the parameters for the stored procedure here
	@OutResultCode INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRY
		
		DECLARE @doc XML;
		DECLARE @NumeroFilasElemento INT;
		DECLARE @NumeroFilasElementoTipoTarifa INT;
		DECLARE @Contador INT;
		DECLARE @IdTipoUnidadActual INT;
		DECLARE @ValorFijo INT;
		--Se crean tablas variables de los datos de entrada para hacer las validaciones

		DECLARE @TempElemento TABLE(
			id INT IDENTITY(1,1)
			, Nombre VARCHAR(64)
			, Valor INT NULL
			, IdTipoUnidad INT
			, EsFijo BIT
		);
		/*DECLARE @TempElementoDeTipoTarifa TABLE(
			id INT IDENTITY(1,1)
			, IdTipoTarifa INT
			, IdTipoElemento INT
			, Valor INT
		);
		DECLARE @TempTipoTarifa TABLE(
			id INT IDENTITY(1,1)
			, Nombre VARCHAR(64)
		);
		DECLARE @TempUnidades TABLE(
			id INT IDENTITY(1,1)
			, Tipo VARCHAR(64)
		);*/
		SET @OutResultCode = 0;
		SET @Contador = 1;
		SELECT @doc = BulkColumn
		FROM OPENROWSET(
			BULK 'C:\config.xml', SINGLE_CLOB
		) AS Data;

		--Insert en tablas variables para hacer validaciones
		
		/*INSERT INTO @TempTipoTarifa(Nombre)
		SELECT Datos.value('@Nombre', 'VARCHAR(64)') AS Nombre
		FROM @doc.nodes('/Data/TiposTarifa/TipoTarifa') AS x1(Datos)

		SELECT * FROM TipoTarifa

		INSERT INTO @TempUnidades(Tipo)
		SELECT Datos.value('@Tipo', 'VARCHAR(64)') AS Tipo
		FROM @doc.nodes('/Data/TiposUnidades/TipoUnidad') AS x1(Datos)*/

		INSERT INTO @TempElemento
		SELECT Datos.value('@Nombre', 'VARCHAR(64)') AS Nombre
			 , Datos.value('@Valor', 'VARCHAR(64)') AS Valor
			 , Datos.value('@IdTipoUnidad', 'INT') AS IdTipoUnidad
			 , Datos.value('@EsFijo', 'BIT') AS EsFijo
		FROM @doc.nodes('/Data/TiposElemento/TipoElemento') AS x1(Datos);

		/*INSERT INTO @TempElementoDeTipoTarifa
		SELECT Datos.value('@idTipoTarifa', 'INT') AS IdTipoTarifa
			 , Datos.value('@IdTipoElemento', 'INT') AS IdTipoElemento
			 , Datos.value('@Valor', 'INT') AS Valor
		FROM @doc.nodes('/Data/ElementosDeTipoTarifa/ElementoDeTipoTarifa') AS x1(Datos);

		SELECT @NumeroFilasElemento = COUNT(*) FROM @TempElemento;
		SELECT @NumeroFilasElementoTipoTarifa = COUNT(*) FROM @TempElementoDeTipoTarifa;

		WHILE @Contador <= @NumeroFilasElemento
		BEGIN
			SELECT @IdTipoUnidadActual = E.IdTipoUnidad FROM @TempElemento AS E WHERE E.id = @Contador
			IF NOT EXISTS (SELECT 1 FROM @TempUnidades AS U WHERE U.id = @IdTipoUnidadActual)
			BEGIN
				--Elimina de la tabla temporal de elementos, el elemento cuya unidad no exista en la tabla de unidades
				DELETE FROM @TempElemento WHERE id = @Contador
			END
		END*/

		--Por ahora no se realizan validaciones porque no se deben ingresar elementos que tengan un tipo de unidad que no exista
		--Esto puede llegar a causar muchos errores de cambio de id's.
		
		BEGIN TRANSACTION
			--Insert del catalogo de tipo tarifa
			
			INSERT INTO dbo.TipoTarifa(Nombre)
			SELECT Datos.value('@Nombre', 'VARCHAR(64)') AS Nombre
			FROM @doc.nodes('/Data/TiposTarifa/TipoTarifa') AS x1(Datos)

			--Insert del catalogo de estado de la factura

			INSERT INTO dbo.EstadoFactura(Nombre)
			VALUES('Pendiente')
				, ('Pagado')
			
			--Insert del catalogo tipo unidades
			INSERT INTO dbo.TipoUnidad(Nombre)
			SELECT Datos.value('@Tipo', 'VARCHAR(64)') AS Tipo
			FROM @doc.nodes('/Data/TiposUnidades/TipoUnidad') AS x1(Datos)

			--Insert del catalogo tipo elemento
			INSERT INTO dbo.TipoElemento(Nombre, IdTipoUnidad, EsFijo)
			SELECT Datos.value('@Nombre', 'VARCHAR(64)') AS Nombre
				 , Datos.value('@IdTipoUnidad', 'INT') AS IdTipoUnidad
				 , Datos.value('@EsFijo', 'BIT') AS EsFijo
			FROM @doc.nodes('/Data/TiposElemento/TipoElemento') AS x1(Datos)

			--Insert del catalogo de valor fijo
			INSERT INTO dbo.ValorFijo(IdTipoElemento, Valor)
			SELECT Id, Valor
			FROM @TempElemento
			WHERE EsFijo = 1

			--Insert del catalogo elementos de tipo tarifa
			INSERT INTO dbo.TipoTarifaXTipoElemento(IdTipoTarifa, IdTipoElemento, Valor)
			SELECT Datos.value('@idTipoTarifa', 'INT') AS IdTipoTarifa
				 , Datos.value('@IdTipoElemento', 'INT') AS IdTipoElemento
				 , Datos.value('@Valor', 'INT') AS Valor
			FROM @doc.nodes('/Data/ElementosDeTipoTarifa/ElementoDeTipoTarifa') AS x1(Datos)

			--Insert del catalogo tipo relaciones familiares
			INSERT INTO dbo.TipoRelacionFamiliar(Nombre)
			SELECT Datos.value('@Nombre', 'VARCHAR(64)') AS Nombre
			FROM @doc.nodes('/Data/TipoRelacionesFamiliar/TipoRelacionFamiliar') AS x1(Datos)

			--Revisar si hacen falta más catálogos

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		SET @OutResultCode = 50005;
	END CATCH

	SET NOCOUNT OFF;
END
