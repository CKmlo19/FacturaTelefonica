USE [SistemaFacturacion]
GO

/****** Object:  Table [dbo].[Contrato]    Script Date: 6/6/2024 02:59:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Contrato](
	[Id] [int] NOT NULL,
	[IdCliente] [int] NULL,
	[Numero] [varchar](64) NULL,
	[IdTipoTarifa] [int] NULL,
 CONSTRAINT [PK_Contrato] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Contrato]  WITH CHECK ADD  CONSTRAINT [FK_Contrato_Clientes] FOREIGN KEY([IdCliente])
REFERENCES [dbo].[Clientes] ([Id])
GO

ALTER TABLE [dbo].[Contrato] CHECK CONSTRAINT [FK_Contrato_Clientes]
GO

ALTER TABLE [dbo].[Contrato]  WITH CHECK ADD  CONSTRAINT [FK_Contrato_TipoTarifa] FOREIGN KEY([IdTipoTarifa])
REFERENCES [dbo].[TipoTarifa] ([Id])
GO

ALTER TABLE [dbo].[Contrato] CHECK CONSTRAINT [FK_Contrato_TipoTarifa]
GO

