﻿CREATE TABLE [dbo].[OMOBJECTACTIONREF] (
    [CASEID]     CHAR (36) NOT NULL,
    [OMOBJECTID] CHAR (36) NOT NULL,
    CONSTRAINT [PK_OMOBJECTActionRef] PRIMARY KEY CLUSTERED ([CASEID] ASC, [OMOBJECTID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_OMOBJECTActionRef_OM] FOREIGN KEY ([OMOBJECTID]) REFERENCES [dbo].[OMOBJECT] ([OMOBJECTID])
);

