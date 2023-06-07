CREATE TYPE [dbo].[WORKFLOW_ACTION_FETCH_TYPE] AS TABLE (
    [ActionId]     CHAR (36) NULL,
    [ActionTypeId] INT       NULL,
    [SubRecordId]  CHAR (36) NULL);

