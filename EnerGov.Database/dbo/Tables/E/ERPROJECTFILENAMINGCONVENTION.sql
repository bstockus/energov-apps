﻿CREATE TABLE [dbo].[ERPROJECTFILENAMINGCONVENTION] (
    [ERPROJECTFILENAMINGCONVENTIONID] INT            NOT NULL,
    [NAME]                            NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]                     NVARCHAR (250) NULL,
    PRIMARY KEY CLUSTERED ([ERPROJECTFILENAMINGCONVENTIONID] ASC)
);

