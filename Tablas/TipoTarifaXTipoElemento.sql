USE [SistemaFacturacion]
GO

/****** Object:  Table [dbo].[TipoTarifaXTipoElemento]    Script Date: 6/6/2024 03:04:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TipoTarifaXTipoElemento](
	[Id] [int] NOT NULL,
	[IdTipoTarifa] [int] NULL,
	[IdTipoElemento] [int] NULL,
	[Valor] [varchar](64) NULL,
 CONSTRAINT [PK_TipoTarifaXTipoElemento] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TipoTarifaXTipoElemento]  WITH CHECK ADD  CONSTRAINT [FK_TipoTarifaXTipoElemento_TipoElemento] FOREIGN KEY([IdTipoElemento])
REFERENCES [dbo].[TipoElemento] ([Id])
GO

ALTER TABLE [dbo].[TipoTarifaXTipoElemento] CHECK CONSTRAINT [FK_TipoTarifaXTipoElemento_TipoElemento]
GO

ALTER TABLE [dbo].[TipoTarifaXTipoElemento]  WITH CHECK ADD  CONSTRAINT [FK_TipoTarifaXTipoElemento_TipoTarifa] FOREIGN KEY([IdTipoTarifa])
REFERENCES [dbo].[TipoTarifa] ([Id])
GO

ALTER TABLE [dbo].[TipoTarifaXTipoElemento] CHECK CONSTRAINT [FK_TipoTarifaXTipoElemento_TipoTarifa]
GO

