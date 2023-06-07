﻿CREATE TABLE [dbo].[CACHARGECODE] (
    [CACHARGECODEID]                CHAR (36)      NOT NULL,
    [CHARGECODE]                    NVARCHAR (100) NOT NULL,
    [DESCRIPTION]                   NVARCHAR (MAX) NULL,
    [CAFINANCIALINTEGRATIONSETUPID] CHAR (36)      NOT NULL,
    CONSTRAINT [PK_CACHARGECODE] PRIMARY KEY CLUSTERED ([CACHARGECODEID] ASC),
    CONSTRAINT [FK_ACHARGECODE_CAFINANCIALINTEGRATIONSETUPID] FOREIGN KEY ([CAFINANCIALINTEGRATIONSETUPID]) REFERENCES [dbo].[CAFINANCIALINTEGRATIONSETUP] ([CAFINANCIALINTEGRATIONSETUPID])
);


GO
CREATE NONCLUSTERED INDEX [CACHARGECODE_IX_FINANCIALINTEGRATIONSETUP_CHARGECODE]
    ON [dbo].[CACHARGECODE]([CAFINANCIALINTEGRATIONSETUPID] ASC, [CHARGECODE] ASC);
