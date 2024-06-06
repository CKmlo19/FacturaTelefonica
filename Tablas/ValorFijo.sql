USE [SistemaFacturacion]
GO

/****** Object:  Table [dbo].[ValorFijo]    Script Date: 6/6/2024 03:04:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ValorFijo](
	[Id] [int] NOT NULL,
	[IdTipoElemento] [int] NULL,
	[Valor] [varchar](64) NULL,
 CONSTRAINT [PK_ValorFijo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ValorFijo]  WITH CHECK ADD  CONSTRAINT [FK_ValorFijo_TipoElemento] FOREIGN KEY([IdTipoElemento])
REFERENCES [dbo].[TipoElemento] ([Id])
GO

ALTER TABLE [dbo].[ValorFijo] CHECK CONSTRAINT [FK_ValorFijo_TipoElemento]
GO

