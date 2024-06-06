USE [SistemaFacturacion]
GO

/****** Object:  Table [dbo].[DetallesLlamadaEstadoCuenta]    Script Date: 6/6/2024 03:01:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DetallesLlamadaEstadoCuenta](
	[Id] [int] NOT NULL,
	[IdEstadoCuentaOperador] [int] NULL,
	[HoraInicio] [datetime] NULL,
	[HoraFin] [datetime] NULL,
	[NumeroIniciaLlamada] [varchar](64) NULL,
	[NumeroContestaLlamada] [varchar](64) NULL,
	[IdDetalleLlamada] [int] NULL,
	[IdFactura] [int] NULL,
 CONSTRAINT [PK_DetallesLlamadaEstadoCuenta] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DetallesLlamadaEstadoCuenta]  WITH CHECK ADD  CONSTRAINT [FK_DetallesLlamadaEstadoCuenta_DetalleLlamada] FOREIGN KEY([IdDetalleLlamada])
REFERENCES [dbo].[DetalleLlamada] ([Id])
GO

ALTER TABLE [dbo].[DetallesLlamadaEstadoCuenta] CHECK CONSTRAINT [FK_DetallesLlamadaEstadoCuenta_DetalleLlamada]
GO

ALTER TABLE [dbo].[DetallesLlamadaEstadoCuenta]  WITH CHECK ADD  CONSTRAINT [FK_DetallesLlamadaEstadoCuenta_EstadoCuentaOperador] FOREIGN KEY([Id])
REFERENCES [dbo].[EstadoCuentaOperador] ([Id])
GO

ALTER TABLE [dbo].[DetallesLlamadaEstadoCuenta] CHECK CONSTRAINT [FK_DetallesLlamadaEstadoCuenta_EstadoCuentaOperador]
GO

ALTER TABLE [dbo].[DetallesLlamadaEstadoCuenta]  WITH CHECK ADD  CONSTRAINT [FK_DetallesLlamadaEstadoCuenta_Factura] FOREIGN KEY([IdFactura])
REFERENCES [dbo].[Factura] ([Id])
GO

ALTER TABLE [dbo].[DetallesLlamadaEstadoCuenta] CHECK CONSTRAINT [FK_DetallesLlamadaEstadoCuenta_Factura]
GO

