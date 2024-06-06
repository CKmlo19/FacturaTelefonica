USE [SistemaFacturacion]
GO

/****** Object:  Table [dbo].[Factura]    Script Date: 6/6/2024 03:02:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Factura](
	[Id] [int] NOT NULL,
	[IdContrato] [int] NULL,
	[IdEstado] [int] NULL,
	[FechaEmision] [datetime] NULL,
	[TotalAPagar] [varchar](64) NULL,
 CONSTRAINT [PK_Facturas] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Factura]  WITH CHECK ADD  CONSTRAINT [FK_Factura_Contrato] FOREIGN KEY([IdContrato])
REFERENCES [dbo].[Contrato] ([Id])
GO

ALTER TABLE [dbo].[Factura] CHECK CONSTRAINT [FK_Factura_Contrato]
GO

ALTER TABLE [dbo].[Factura]  WITH CHECK ADD  CONSTRAINT [FK_Factura_EstadoFactura] FOREIGN KEY([IdEstado])
REFERENCES [dbo].[EstadoFactura] ([Id])
GO

ALTER TABLE [dbo].[Factura] CHECK CONSTRAINT [FK_Factura_EstadoFactura]
GO

