USE [SistemaFacturacion]
GO

/****** Object:  Table [dbo].[DetalleFactura]    Script Date: 6/6/2024 03:01:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DetalleFactura](
	[Id] [int] NOT NULL,
	[IdFactura] [int] NULL,
	[TotalConIVA] [varchar](64) NULL,
	[TotalSinIVA] [varchar](64) NULL,
	[MultaPorAtraso] [varchar](64) NULL,
	[FechaPago] [datetime] NULL,
 CONSTRAINT [PK_DetalleFactura] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DetalleFactura]  WITH CHECK ADD  CONSTRAINT [FK_DetalleFactura_Factura] FOREIGN KEY([IdFactura])
REFERENCES [dbo].[Factura] ([Id])
GO

ALTER TABLE [dbo].[DetalleFactura] CHECK CONSTRAINT [FK_DetalleFactura_Factura]
GO

