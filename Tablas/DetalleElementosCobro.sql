USE [SistemaFacturacion]
GO

/****** Object:  Table [dbo].[DetalleElementosCobro]    Script Date: 6/6/2024 03:00:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DetalleElementosCobro](
	[Id] [int] NOT NULL,
	[IdDetalleFactura] [int] NULL,
	[TarifaBasica] [varchar](64) NULL,
	[QMinutosExceso] [varchar](64) NULL,
	[QGigasExceso] [varchar](64) NULL,
	[QFamiliar] [varchar](64) NULL,
	[Llamada911] [varchar](64) NULL,
	[Llamada110] [varchar](64) NULL,
	[Llamada900] [varchar](64) NULL,
	[Llamada800] [varchar](64) NULL,
	[Llamada7] [varchar](64) NULL,
	[Llamada6] [varchar](64) NULL,
 CONSTRAINT [PK_DetalleElementosCobro] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DetalleElementosCobro]  WITH CHECK ADD  CONSTRAINT [FK_DetalleElementosCobro_DetalleFactura] FOREIGN KEY([IdDetalleFactura])
REFERENCES [dbo].[DetalleFactura] ([Id])
GO

ALTER TABLE [dbo].[DetalleElementosCobro] CHECK CONSTRAINT [FK_DetalleElementosCobro_DetalleFactura]
GO

