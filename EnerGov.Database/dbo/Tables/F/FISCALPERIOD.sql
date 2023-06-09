﻿CREATE TABLE [dbo].[FISCALPERIOD] (
    [FISCALPERIODID] CHAR (36)    NOT NULL,
    [STARTDATE]      DATETIME     NOT NULL,
    [ENDDATE]        DATETIME     NOT NULL,
    [STARTYEAR]      INT          NOT NULL,
    [STARTMONTH]     VARCHAR (30) NULL,
    [PERIOD]         VARCHAR (50) NOT NULL,
    [QUARTER]        SMALLINT     NULL,
    [PERIODOPEN]     BIT          NULL,
    CONSTRAINT [PK_FiscalPeriod] PRIMARY KEY CLUSTERED ([FISCALPERIODID] ASC) WITH (FILLFACTOR = 90)
);

