﻿CREATE TABLE [dbo].[ENERGOVWIDGET] (
    [WIDGETID]     CHAR (36)      NOT NULL,
    [TYPENAME]     NVARCHAR (255) NULL,
    [WIDGETNAME]   NVARCHAR (255) NULL,
    [SDESCRIPTION] NVARCHAR (255) NULL,
    [IMAGEPATH]    VARCHAR (255)  NULL,
    [TEXT1]        NVARCHAR (255) NULL,
    [TEXT2]        NVARCHAR (255) NULL,
    CONSTRAINT [PK_EnerGovWidget] PRIMARY KEY CLUSTERED ([WIDGETID] ASC) WITH (FILLFACTOR = 90)
);

