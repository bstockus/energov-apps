CREATE TABLE [dbo].[BINITEM] (
    [INBINITEMID]             CHAR (36)       NOT NULL,
    [QUANTITY]                NUMERIC (38, 5) NOT NULL,
    [UNITOFMEASURE]           CHAR (36)       NOT NULL,
    [UNITOFMEASURE2]          CHAR (36)       NULL,
    [QUANTITY_UNITOFMEASURE2] NUMERIC (18)    NULL,
    [INBINID]                 CHAR (36)       NULL,
    [ITEMID]                  CHAR (36)       NULL,
    [AVERAGEUNITCOST]         MONEY           NOT NULL,
    [AVERAGEUNITCOST2]        MONEY           NULL,
    [PICKTIME]                DECIMAL (6, 2)  NULL,
    CONSTRAINT [PK_BinItem_1] PRIMARY KEY CLUSTERED ([INBINITEMID] ASC) WITH (FILLFACTOR = 90)
);

