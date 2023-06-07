﻿CREATE TABLE [dbo].[SERVICETASKHISTORYDETAIL] (
    [SERVICETASKHISTORYDETAILID] CHAR (36)      NOT NULL,
    [SERVICETASKHISTORYID]       CHAR (36)      NOT NULL,
    [ENTITYTYPE]                 NVARCHAR (250) NOT NULL,
    [ENTITYID]                   CHAR (36)      NOT NULL,
    [ENTITYNUMBER]               NVARCHAR (100) NULL,
    [STARTTIME]                  DATETIME       NULL,
    [ENDTIME]                    DATETIME       NULL,
    [RESULT]                     NVARCHAR (50)  NULL,
    [ERROR]                      NVARCHAR (MAX) NULL,
    [WASRERUN]                   BIT            DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_SERVICETASKHISTORYDETAIL] PRIMARY KEY NONCLUSTERED ([SERVICETASKHISTORYDETAILID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_SERVICETASKHISTORYDET_HST] FOREIGN KEY ([SERVICETASKHISTORYID]) REFERENCES [dbo].[SERVICETASKHISTORY] ([SERVICETASKHISTORYID])
);


GO
CREATE NONCLUSTERED INDEX [IX_SERVICETASKHISTORY_HIST]
    ON [dbo].[SERVICETASKHISTORYDETAIL]([SERVICETASKHISTORYID] ASC);
