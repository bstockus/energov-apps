﻿CREATE TABLE [dbo].[PUREQUISITIONSTATUS] (
    [PUREQUISITIONSTATUSID] CHAR (36)      NOT NULL,
    [NAME]                  VARCHAR (50)   NOT NULL,
    [DESCRIPTION]           NVARCHAR (MAX) NULL,
    [SYSTEMACTIONID]        CHAR (36)      NOT NULL,
    CONSTRAINT [PK_PURequistionStatus] PRIMARY KEY CLUSTERED ([PUREQUISITIONSTATUSID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PUReqStatus_SysAct] FOREIGN KEY ([SYSTEMACTIONID]) REFERENCES [dbo].[SYSTEMACTION] ([SYSTEMACTIONID])
);
