USE [SistemaFacturacion]
GO

/****** Object:  Table [dbo].[RelacionFamiliar]    Script Date: 6/6/2024 03:03:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[RelacionFamiliar](
	[Id] [int] NOT NULL,
	[IdCliente1] [int] NULL,
	[IdCliente2] [int] NULL,
	[IdTipoRelacionFamiliar] [int] NULL,
 CONSTRAINT [PK_RelacionFamiliar] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[RelacionFamiliar]  WITH CHECK ADD  CONSTRAINT [FK_RelacionFamiliar_Clientes] FOREIGN KEY([IdCliente1])
REFERENCES [dbo].[Clientes] ([Id])
GO

ALTER TABLE [dbo].[RelacionFamiliar] CHECK CONSTRAINT [FK_RelacionFamiliar_Clientes]
GO

ALTER TABLE [dbo].[RelacionFamiliar]  WITH CHECK ADD  CONSTRAINT [FK_RelacionFamiliar_Clientes1] FOREIGN KEY([IdCliente2])
REFERENCES [dbo].[Clientes] ([Id])
GO

ALTER TABLE [dbo].[RelacionFamiliar] CHECK CONSTRAINT [FK_RelacionFamiliar_Clientes1]
GO

ALTER TABLE [dbo].[RelacionFamiliar]  WITH CHECK ADD  CONSTRAINT [FK_RelacionFamiliar_TipoRelacionFamiliar] FOREIGN KEY([IdTipoRelacionFamiliar])
REFERENCES [dbo].[TipoRelacionFamiliar] ([Id])
GO

ALTER TABLE [dbo].[RelacionFamiliar] CHECK CONSTRAINT [FK_RelacionFamiliar_TipoRelacionFamiliar]
GO

