CREATE TABLE [dbo].[PMPERMITHOLDUPLOAD] (
    [PMPERMITHOLDUPLOADID] CHAR (36)      NOT NULL,
    [PMPERMITID]           CHAR (36)      NULL,
    [HOLDSETUPID]          CHAR (36)      NULL,
    [COMMENTS]             NVARCHAR (MAX) NULL,
    [SUSERGUID]            CHAR (36)      NULL,
    [CREATEDDATE]          DATETIME       NULL,
    [ORIGIN]               CHAR (36)      NULL,
    [ORIGINNUMBER]         NVARCHAR (150) NULL,
    [UPLOADED]             BIT            NULL,
    [ACTIVE]               BIT            NULL,
    [ISDELETE]             BIT            NULL,
    CONSTRAINT [PK_PMPermitHoldUpload] PRIMARY KEY CLUSTERED ([PMPERMITHOLDUPLOADID] ASC) WITH (FILLFACTOR = 90)
);

