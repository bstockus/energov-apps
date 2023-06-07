CREATE TABLE [dbo].[temp_dru_log] (
    [id]            CHAR (36)      NULL,
    [DestinationDB] NVARCHAR (128) NULL,
    [SourceDB]      NVARCHAR (128) NULL,
    [BackupFile]    NVARCHAR (500) NULL,
    [DRU_Action]    NVARCHAR (50)  NULL,
    [Log_Date]      DATETIME       NULL,
    [DRU_version]   NVARCHAR (50)  NULL,
    [error_flag]    BIT            NULL,
    [error_message] NVARCHAR (MAX) NULL,
    [succuss_flag]  BIT            NULL
);

