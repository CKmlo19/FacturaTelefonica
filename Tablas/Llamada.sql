USE [SistemaFacturacion]
GO

/****** Object:  Table [dbo].[Llamada]    Script Date: 6/6/2024 03:03:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Llamada](
	[Id] [int] NOT NULL,
	[NumeroDe] [varchar](64) NULL,
	[NumeroA] [varchar](64) NULL,
	[FechaInicio] [datetime] NULL,
	[FechaFin] [datetime] NULL,
 CONSTRAINT [PK_Llamada] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Llamada]  WITH CHECK ADD  CONSTRAINT [FK_Llamada_LlamadaNoLocal] FOREIGN KEY([Id])
REFERENCES [dbo].[LlamadaNoLocal] ([Id])
GO

ALTER TABLE [dbo].[Llamada] CHECK CONSTRAINT [FK_Llamada_LlamadaNoLocal]
GO

