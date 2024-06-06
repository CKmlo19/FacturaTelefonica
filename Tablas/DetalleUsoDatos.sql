USE [SistemaFacturacion]
GO

/****** Object:  Table [dbo].[DetalleUsoDatos]    Script Date: 6/6/2024 03:02:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DetalleUsoDatos](
	[Id] [int] NOT NULL,
	[IdFactura] [int] NULL,
	[IdUsoDatos] [int] NULL,
	[QGigas] [float] NULL,
 CONSTRAINT [PK_DetalleUsoDatos] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DetalleUsoDatos]  WITH CHECK ADD  CONSTRAINT [FK_DetalleUsoDatos_Factura] FOREIGN KEY([IdFactura])
REFERENCES [dbo].[Factura] ([Id])
GO

ALTER TABLE [dbo].[DetalleUsoDatos] CHECK CONSTRAINT [FK_DetalleUsoDatos_Factura]
GO

ALTER TABLE [dbo].[DetalleUsoDatos]  WITH CHECK ADD  CONSTRAINT [FK_DetalleUsoDatos_UsoDatos] FOREIGN KEY([IdUsoDatos])
REFERENCES [dbo].[UsoDatos] ([Id])
GO

ALTER TABLE [dbo].[DetalleUsoDatos] CHECK CONSTRAINT [FK_DetalleUsoDatos_UsoDatos]
GO

