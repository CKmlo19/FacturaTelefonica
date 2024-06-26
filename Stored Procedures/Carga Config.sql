USE [SistemaFacturacion]
GO
/****** Object:  StoredProcedure [dbo].[CargaConfig]    Script Date: 11/6/2024 20:06:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CargaConfig]

AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @XMLDoc XML;

-- Lee el archivo XML y lo almacena en la variable @XMLDoc
SELECT @XMLDoc = CAST(BulkColumn AS XML)
FROM OPENROWSET(BULK 'C:\Users\sebas\Desktop\Bases de Datos I\Tarea Programada #3\config.xml', SINGLE_BLOB) AS x;

-- Inserta los datos del XML en la tabla temporal
INSERT INTO dbo.TipoTarifa(id, Nombre)
SELECT
    Xml.value('@Id', 'INT'),
    Xml.value('@Nombre', 'VARCHAR(64)')
FROM @XMLDoc.nodes('/Data/TiposTarifa/TipoTarifa') AS XTbl(Xml);

INSERT INTO dbo.TipoUnidad(id, Nombre)
SELECT
    Xml.value('@Id', 'INT'),
    Xml.value('@Tipo', 'VARCHAR(64)')
FROM @XMLDoc.nodes('/Data/TiposUnidades/TipoUnidad') AS XTbl(Xml);

INSERT INTO dbo.ElementoTipoTarifa(id, idTipoUnidad, Nombre, EsFijo)
SELECT
    Xml.value('@Id', 'INT'),
	Xml.value('@IdTipoUnidad', 'INT'),
    Xml.value('@Nombre', 'VARCHAR(64)'),
	Xml.value('@EsFijo', 'BIT')
FROM @XMLDoc.nodes('/Data/TiposElemento/TipoElemento') AS XTbl(Xml)

INSERT INTO dbo.ValorFijo(IdElementoTipoTarifa, Valor)
SELECT
    Xml.value('@Id', 'INT'),
    Xml.value('@Valor', 'INT')
FROM @XMLDoc.nodes('/Data/TiposElemento/TipoElemento') AS XTbl(Xml)
WHERE Xml.value('@EsFijo', 'BIT') = 1;

INSERT INTO dbo.TipoTarifaXElementoTipoTarifa(idTipoTarifa, idElementoTipoTarifa, Valor)
SELECT
	Xml.value('@idTipoTarifa', 'INT'),
    Xml.value('@IdTipoElemento', 'INT'),
	Xml.value('@Valor', 'VARCHAR(64)')
FROM @XMLDoc.nodes('/Data/ElementosDeTipoTarifa/ElementoDeTipoTarifa') AS XTbl(Xml);

INSERT INTO dbo.TipoRelacionFamiliar(id, Nombre)
SELECT
    Xml.value('@Id', 'INT'),
    Xml.value('@Nombre', 'VARCHAR(64)')
FROM @XMLDoc.nodes('/Data/TipoRelacionesFamiliar/TipoRelacionFamiliar') AS XTbl(Xml);

END