USE TEST;
GO

DROP VIEW IF EXISTS dbo.vMarkets;
DROP VIEW IF EXISTS dbo.vProducts;
DROP VIEW IF EXISTS dbo.vResidue;
DROP VIEW IF EXISTS dbo.vSuppliers;
DROP VIEW IF EXISTS dbo.vTestResult;

DROP TABLE IF EXISTS dbo.tMarkets;
DROP TABLE IF EXISTS dbo.tProducts;
DROP TABLE IF EXISTS dbo.tResidue;
DROP TABLE IF EXISTS dbo.tSuppliers;
DROP TABLE IF EXISTS dbo.tTestResult;

DROP PROCEDURE IF EXISTS dbo.prcUpdateTable;

USE [msdb]
GO
EXEC msdb.dbo.sp_delete_job @job_name=N'Обновление таблицы', @delete_unused_schedule=1
GO