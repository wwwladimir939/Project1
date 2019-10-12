USE TEST;
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tTestResult](
    [spId]         [INTEGER] NOT NULL,
    [skuId]        [INTEGER] NOT NULL,
    [cntrId]       [INTEGER]     NULL,
    [isOutOfStock] [BIT]     NOT NULL,
    [isReserved]   [BIT]     NOT NULL,
    [skuPcs]       [INTEGER]     NULL,
    [spName]       [VARCHAR](64) NULL,
    [skuName]      [VARCHAR](64) NULL,
 CONSTRAINT [pkResult] PRIMARY KEY CLUSTERED 
(
    [spId]  ASC,
    [skuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO