USE TEST;
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tResidue](
    [id]            [INTEGER] IDENTITY(1,1) NOT NULL,
    [date]          [DATETIME]                  NULL,
    [marketId]      [INTEGER]                   NULL,
    [supplerId]     [INTEGER]                   NULL,
    [produktId]     [INTEGER]                   NULL,
    [positionCount] [INTEGER]                   NULL,
    [isReserved]    [BIT]                       NULL,
 CONSTRAINT [PK_tResidue] PRIMARY KEY CLUSTERED 
(
    [id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO