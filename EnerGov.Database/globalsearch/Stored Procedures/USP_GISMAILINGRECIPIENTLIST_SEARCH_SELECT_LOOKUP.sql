﻿CREATE PROCEDURE [globalsearch].[USP_GISMAILINGRECIPIENTLIST_SEARCH_SELECT_LOOKUP]
(
    @SEARCH AS NVARCHAR(MAX) = ''
)
AS
BEGIN
SET NOCOUNT ON;
;WITH RAW_DATA
    AS(        
        SELECT
            [GISMAILINGRECIPIENTLIST].[GISMAILINGRECIPIENTLISTID],
            [GISMAILINGRECIPIENTLIST].[NAME],
            [GISMAILINGRECIPIENTLIST].[DESCRIPTION],
            ROW_NUMBER() OVER (
                PARTITION BY [GISMAILINGRECIPIENTLIST].[NAME],
                                [GISMAILINGRECIPIENTLIST].[DESCRIPTION]
                ORDER BY [GISMAILINGRECIPIENTLIST].[CREATEDDATE] DESC) AS ORDINAL
        FROM
            [dbo].[GISMAILINGRECIPIENTLIST] WITH (NOLOCK) INNER JOIN [dbo].[GISMAILINGBUFFERDATA] WITH (NOLOCK)
            ON [GISMAILINGRECIPIENTLIST].[GISMAILINGRECIPIENTLISTID]
                = [GISMAILINGBUFFERDATA].[GISMAILINGRECIPIENTLISTID]
        WHERE
            [GISMAILINGRECIPIENTLIST].[NAME] like '%'+@SEARCH+'%'
            OR [GISMAILINGRECIPIENTLIST].[DESCRIPTION] like '%'+@SEARCH+'%'
)
SELECT TOP 1
    [GISMAILINGRECIPIENTLISTID],
    [NAME],
    [DESCRIPTION]
FROM RAW_DATA
WHERE
  ORDINAL = 1;
END