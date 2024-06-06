USE [SistemaFacturacion]
GO

/****** Object:  Table [dbo].[EstadoCuentaOperador]    Script Date: 6/6/2024 03:02:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EstadoCuentaOperador](
	[Id] [int] NOT NULL,
	[IdOperador] [int] NULL,
	[IdTipoLlamadaOperador] [int] NULL,
	[TotalMinutosIN] [varchar](64) NULL,
	[TotalMinutosOUT] [varchar](64) NULL,
 CONSTRAINT [PK_EstadoCuentaOperador] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[EstadoCuentaOperador]  WITH CHECK ADD  CONSTRAINT [FK_EstadoCuentaOperador_Operador] FOREIGN KEY([IdOperador])
REFERENCES [dbo].[Operador] ([Id])
GO

ALTER TABLE [dbo].[EstadoCuentaOperador] CHECK CONSTRAINT [FK_EstadoCuentaOperador_Operador]
GO

ALTER TABLE [dbo].[EstadoCuentaOperador]  WITH CHECK ADD  CONSTRAINT [FK_EstadoCuentaOperador_TipoLlamadaOperador] FOREIGN KEY([IdTipoLlamadaOperador])
REFERENCES [dbo].[TipoLlamadaOperador] ([Id])
GO

ALTER TABLE [dbo].[EstadoCuentaOperador] CHECK CONSTRAINT [FK_EstadoCuentaOperador_TipoLlamadaOperador]
GO

