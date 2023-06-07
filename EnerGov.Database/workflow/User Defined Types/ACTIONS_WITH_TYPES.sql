CREATE TYPE [workflow].[ACTIONS_WITH_TYPES] AS TABLE (
    [ActionId]     CHAR (36) NOT NULL,
    [ActionTypeId] INT       NULL,
    [RelatedId]    CHAR (36) NULL);

