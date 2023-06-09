﻿CREATE TABLE [dbo].[PLPLANRECOMMENDATION] (
    [PLPLANRECOMENDATIONID]         CHAR (36)      NOT NULL,
    [RECOMMENDATION]                NVARCHAR (MAX) NOT NULL,
    [AUTONUMBER]                    CHAR (20)      NOT NULL,
    [PLITEMREVIEWID]                CHAR (36)      NOT NULL,
    [ERPROJECTFILEVERSIONID]        CHAR (36)      NULL,
    [CREATEDATE]                    DATETIME       NOT NULL,
    [ADDEDBYUSERID]                 CHAR (36)      NOT NULL,
    [LASTCHANGEDON]                 DATETIME       NOT NULL,
    [LASTCHANGEDBY]                 CHAR (36)      NOT NULL,
    [PREVIOUSPLPLANRECOMENDATIONID] CHAR (36)      NULL,
    CONSTRAINT [PK_PLPlanCorrectionRecom] PRIMARY KEY CLUSTERED ([PLPLANRECOMENDATIONID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PLPlanRecom_PLItemReview] FOREIGN KEY ([PLITEMREVIEWID]) REFERENCES [dbo].[PLITEMREVIEW] ([PLITEMREVIEWID]),
    CONSTRAINT [FK_PLPlanRecom_Users] FOREIGN KEY ([ADDEDBYUSERID]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_PLPlanRecommendation_PLPlanRecommendation] FOREIGN KEY ([PREVIOUSPLPLANRECOMENDATIONID]) REFERENCES [dbo].[PLPLANRECOMMENDATION] ([PLPLANRECOMENDATIONID]),
    CONSTRAINT [FK_PLRecom_Users] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_Rec_ERProjectFileVersion] FOREIGN KEY ([ERPROJECTFILEVERSIONID]) REFERENCES [dbo].[ERPROJECTFILEVERSION] ([ERPROJECTFILEVERSIONID])
);


GO
CREATE NONCLUSTERED INDEX [IX_PLPLANRECOMMENDATION_PLITEMREVIEWID]
    ON [dbo].[PLPLANRECOMMENDATION]([PLITEMREVIEWID] ASC)
    INCLUDE([RECOMMENDATION], [ADDEDBYUSERID]);


GO
CREATE NONCLUSTERED INDEX [IX_PLPLANRECOMMENDATION_PREVIOUSPLPLANRECOMENDATIONID]
    ON [dbo].[PLPLANRECOMMENDATION]([PREVIOUSPLPLANRECOMENDATIONID] ASC)
    INCLUDE([PLPLANRECOMENDATIONID]);

