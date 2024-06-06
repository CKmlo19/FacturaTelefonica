USE [SistemaFacturacion]
GO

/****** Object:  Table [dbo].[TipoRelacionFamiliar]    Script Date: 6/6/2024 03:04:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TipoRelacionFamiliar](
	[Id] [int] NOT NULL,
	[Nombre] [varchar](64) NULL,
 CONSTRAINT [PK_TipoRelacionFamiliar] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

