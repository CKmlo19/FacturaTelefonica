USE [SistemaFacturacion]
GO

/****** Object:  Table [dbo].[DetalleLlamada]    Script Date: 6/6/2024 03:01:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DetalleLlamada](
	[Id] [int] NOT NULL,
	[IdLlamada] [int] NULL,
	[IdFactura] [int] NULL,
	[QMinutos] [varchar](64) NULL,
	[EsGratis] [bit] NULL,
 CONSTRAINT [PK_DetalleLlamada] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DetalleLlamada]  WITH CHECK ADD  CONSTRAINT [FK_DetalleLlamada_Llamada] FOREIGN KEY([IdLlamada])
REFERENCES [dbo].[Llamada] ([Id])
GO

ALTER TABLE [dbo].[DetalleLlamada] CHECK CONSTRAINT [FK_DetalleLlamada_Llamada]
GO

