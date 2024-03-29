USE TEST;
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tProducts](
    [id]   [INTEGER] IDENTITY(1,1) NOT NULL,
    [name] [NVARCHAR](50)              NULL,
 CONSTRAINT [PK_tProdukts] PRIMARY KEY CLUSTERED 
(
    [id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [AK_tProducts] UNIQUE NONCLUSTERED 
(
    [name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tMarkets](
    [id]   [INTEGER] IDENTITY(1,1) NOT NULL,
    [name] [NVARCHAR](50)              NULL,
 CONSTRAINT [PK_tMarkets] PRIMARY KEY CLUSTERED 
(
    [id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [AK_tMarkets] UNIQUE NONCLUSTERED 
(
    [name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
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

CREATE TABLE [dbo].[tSuppliers](
    [id]   [INTEGER] IDENTITY(1,1) NOT NULL,
    [name] [NVARCHAR](50)              NULL,
 CONSTRAINT [PK_tSupplers] PRIMARY KEY CLUSTERED
(
    [id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [AK_tSupplers] UNIQUE NONCLUSTERED
(
    [name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
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

CREATE VIEW [dbo].[vMarkets]
AS
SELECT
    id,
    name
FROM dbo.tMarkets
GO

CREATE VIEW [dbo].[vProducts]
AS
SELECT
    id,
    name
FROM dbo.tProducts
GO

CREATE VIEW [dbo].[vSuppliers]
AS
SELECT
    id,
    name
FROM dbo.tSuppliers
GO
                                                                                                                                                                                 
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

INSERT INTO dbo.tMarkets (name)
VALUES ('market1'), ('market2'),('market3'),('market4'),('market5'),('market6'),('market7'),('market8'),('market9'),('market10')

INSERT INTO dbo.tProducts (name)
VALUES ('prod1'), ('prod2'), ('prod3'), ('prod4'), ('prod5'), ('prod6'), ('prod7'), ('prod8'), ('prod9'), ('prod10')

INSERT INTO dbo.tSuppliers (name)
VALUES ('supp1'), ('supp2'),('supp3'), ('supp4'),('supp5'), ('supp6'),('supp7'), ('supp8'),('supp9'), ('supp10')

INSERT INTO dbo.tResidue (date, marketId, supplerId, produktId,positionCount, isReserved) 
VALUES (GETDATE(), 1,2,3,123,1), (GETDATE(), 2,3,4,234,1),(GETDATE(), 3,4,5,345,0),(GETDATE(), 4,5,6,456,0),(GETDATE(), 5,6,7,567,0),(GETDATE(), 6,7,8,678,1),(GETDATE(), 7,8,9,789,0),(GETDATE(), 8,9,10,12,0),(GETDATE(), 9,10,1,53,0),(GETDATE(), 10,1,2,151,1)

USE [msdb]
GO

/****** Object:  Job [���������� �������]    Script Date: 11.10.2019 23:57:35 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 11.10.2019 23:57:35 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'���������� �������',
        @enabled=1,
        @notify_level_eventlog=0,
        @notify_level_email=0,
        @notify_level_netsend=0,
        @notify_level_page=0,
        @delete_level=0,
        @description=N'���������� ������� tTestResult.
�� ������ � 9 �� 18 ������ 30 �����.',
        @category_name=N'[Uncategorized (Local)]',
        @owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [������ ���������]    Script Date: 11.10.2019 23:57:35 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'������ ���������',
        @step_id=1,
        @cmdexec_success_code=0,
        @on_success_action=1,
        @on_success_step_id=0,
        @on_fail_action=2,
        @on_fail_step_id=0,
        @retry_attempts=0,
        @retry_interval=0,
        @os_run_priority=0, @subsystem=N'TSQL',
        @command=N'EXECUTE dbo.prcUpdateTable',
        @database_name=N'TEST',
        @flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'������� ���',
        @enabled=1,
        @freq_type=8,
        @freq_interval=62,
        @freq_subday_type=4,
        @freq_subday_interval=30,
        @freq_relative_interval=0,
        @freq_recurrence_factor=1,
        @active_start_date=20191011,
        @active_end_date=99991231,
        @active_start_time=90000,
        @active_end_time=180000,
        @schedule_uid=N'31c08bd4-10b7-4095-b235-d4b3f3777814'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO