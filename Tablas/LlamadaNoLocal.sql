USE [SistemaFacturacion]
GO

/****** Object:  Table [dbo].[LlamadaNoLocal]    Script Date: 6/6/2024 03:03:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LlamadaNoLocal](
	[Id] [int] NOT NULL,
	[IdLlamadas] [int] NULL,
	[IdOperador] [int] NULL,
 CONSTRAINT [PK_LlamadaNoLocal] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[LlamadaNoLocal]  WITH CHECK ADD  CONSTRAINT [FK_LlamadaNoLocal_Operador] FOREIGN KEY([IdOperador])
REFERENCES [dbo].[Operador] ([Id])
GO

ALTER TABLE [dbo].[LlamadaNoLocal] CHECK CONSTRAINT [FK_LlamadaNoLocal_Operador]
GO

