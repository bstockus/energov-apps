CREATE TABLE [dbo].[MOBILEGOVTRICKLEUPDATES] (
    [MOBILEGOVTRICKLEUPDATESID] CHAR (36)       NOT NULL,
    [USERID]                    NVARCHAR (36)   NOT NULL,
    [UPDATETIME]                DATETIME        NULL,
    [SENT]                      BIT             DEFAULT ((0)) NULL,
    [APPLIED]                   BIT             DEFAULT ((0)) NULL,
    [UPDATEOBJECT]              VARBINARY (MAX) NULL,
    [APPLY_ATTEMPT]             INT             NULL,
    CONSTRAINT [PK_MobileGovTrickleUpdates] PRIMARY KEY CLUSTERED ([MOBILEGOVTRICKLEUPDATESID] ASC) WITH (FILLFACTOR = 90)
);

