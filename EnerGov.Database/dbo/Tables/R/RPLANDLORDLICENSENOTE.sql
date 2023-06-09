﻿CREATE TABLE [dbo].[RPLANDLORDLICENSENOTE] (
    [RPLANDLORDLICENSENOTEID] CHAR (36)      NOT NULL,
    [RPLANDLORDLICENSEID]     CHAR (36)      NOT NULL,
    [TEXT]                    NVARCHAR (MAX) NULL,
    [CREATEDBY]               CHAR (36)      NOT NULL,
    [CREATEDDATE]             DATETIME       NOT NULL,
    CONSTRAINT [PK_RPLANDLORDLICENSENOTE] PRIMARY KEY NONCLUSTERED ([RPLANDLORDLICENSENOTEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_RPLANDLORDLICENSENOTE_USERS] FOREIGN KEY ([CREATEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_RPLLLICNOTE_lLLLICENSE] FOREIGN KEY ([RPLANDLORDLICENSEID]) REFERENCES [dbo].[RPLANDLORDLICENSE] ([RPLANDLORDLICENSEID])
);

