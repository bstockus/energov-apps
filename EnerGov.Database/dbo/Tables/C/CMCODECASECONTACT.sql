﻿CREATE TABLE [dbo].[CMCODECASECONTACT] (
    [CMCODECASECONTACTID]     CHAR (36) NOT NULL,
    [CMCODECASEID]            CHAR (36) NOT NULL,
    [GLOBALENTITYID]          CHAR (36) NOT NULL,
    [CMCODECASECONTACTTYPEID] CHAR (36) NOT NULL,
    [ISBILLING]               BIT       CONSTRAINT [DF_CMCodeCaseContact_Billing] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CodeContactXref] PRIMARY KEY CLUSTERED ([CMCODECASECONTACTID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_CMCodeContact_Type] FOREIGN KEY ([CMCODECASECONTACTTYPEID]) REFERENCES [dbo].[CMCODECASECONTACTTYPE] ([CMCODECASECONTACTTYPEID]),
    CONSTRAINT [FK_CodeContact_CodeCase] FOREIGN KEY ([CMCODECASEID]) REFERENCES [dbo].[CMCODECASE] ([CMCODECASEID]),
    CONSTRAINT [FK_CodeContactXRef_GlobalEntity] FOREIGN KEY ([GLOBALENTITYID]) REFERENCES [dbo].[GLOBALENTITY] ([GLOBALENTITYID])
);


GO
CREATE NONCLUSTERED INDEX [IX_CMCODECASECONTACT_ENTITY]
    ON [dbo].[CMCODECASECONTACT]([CMCODECASEID] ASC, [GLOBALENTITYID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IX_CMCODECASECONTACT_GLOBALENTITY]
    ON [dbo].[CMCODECASECONTACT]([GLOBALENTITYID] ASC);
