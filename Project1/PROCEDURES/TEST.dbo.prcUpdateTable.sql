USE TEST;
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[prcUpdateTable]
AS
BEGIN
    MERGE dbo.tTestResult AS target
    USING (SELECT
               a.marketId,
               a.produktId,
               a.supplerId,
               CASE
                   WHEN a.positionCount > 0
                   THEN 1
                   ELSE 0
               END,
               a.isReserved,
               a.positionCount,
               b.name,
               c.name
           FROM tResidue AS a
           INNER JOIN vMarkets AS b ON a.marketId = b.id
           INNER JOIN vProducts AS c ON a.produktId = c.id
           GROUP BY 
               a.marketId,
               a.produktId,
               a.supplerId,
               a.isReserved,
               a.positionCount,
               b.name,
               c.name
          )
    AS source (marketId, productId, supplerId, isOutOfStock, isReserved, skuPcs, spName, skuName)
    ON (target.skuId = source.productid
        AND target.spId = source.marketId
        AND cntrId = source.supplerId
        AND target.skuPcs = source.skuPcs
        AND target.skuName = source.skuName)
    WHEN MATCHED THEN UPDATE 
    SET target.spId = source.marketId,
        target.skuId = source.productId,
        target.cntrId = source.supplerId,
        target.isOutOfStock = source.isOutOfStock,
        target.isReserved = source.isReserved,
        target.skuPcs = source.skuPcs,
        target.skuName = source.skuName
    WHEN NOT MATCHED
    THEN INSERT (spId, skuId, cntrId, isOutOfStock, isReserved, skuPcs, spName, skuName)
    VALUES (marketId, productId, supplerId, isOutOfStock, isReserved, skuPcs, spName, skuName)
    OUTPUT $action;
END
GO