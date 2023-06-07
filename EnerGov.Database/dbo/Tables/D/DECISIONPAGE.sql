﻿CREATE TABLE [dbo].[DECISIONPAGE] (
    [DECISIONPAGEID]                CHAR (36)     NOT NULL,
    [PARENTDECISIONQUESTIONNAIREID] CHAR (36)     NOT NULL,
    [CUSTOMFIELDLAYOUTID]           CHAR (36)     NULL,
    [PAGENAME]                      NVARCHAR (50) NOT NULL,
    [PARENTDECISIONPAGEID]          CHAR (36)     NULL,
    [DECISIONQUESTIONNAIREID]       CHAR (36)     NULL,
    [DECISIONAPPID]                 CHAR (36)     NULL,
    [DECISIONPAGETYPEID]            INT           CONSTRAINT [DF_DecisionPageTypeID] DEFAULT ((1)) NOT NULL,
    [DECISIONPREFABID]              INT           NULL,
    [DECISIONPARCELID]              CHAR (36)     NULL,
    [DECISIONADDRESSID]             CHAR (36)     NULL,
    [DECISIONCONTACTID]             CHAR (36)     NULL,
    [DECISIONPERMITID]              CHAR (36)     NULL,
    [DECISIONPLANID]                CHAR (36)     NULL,
    [DECISIONREQUESTID]             CHAR (36)     NULL,
    [DECISIONPROJECTID]             CHAR (36)     NULL,
    [DECISIONPREFPERMITID]          CHAR (36)     NULL,
    [ISDELETED]                     BIT           DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_DecisionPage] PRIMARY KEY CLUSTERED ([DECISIONPAGEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Decisio_CustomLayout] FOREIGN KEY ([CUSTOMFIELDLAYOUTID]) REFERENCES [dbo].[CUSTOMFIELDLAYOUT] ([GCUSTOMFIELDLAYOUTS]),
    CONSTRAINT [FK_DECISIONPAGE_DECISIONADDRES] FOREIGN KEY ([DECISIONADDRESSID]) REFERENCES [dbo].[DECISIONADDRESS] ([DECISIONADDRESSID]),
    CONSTRAINT [FK_DECISIONPAGE_DECISIONCONTAC] FOREIGN KEY ([DECISIONCONTACTID]) REFERENCES [dbo].[DECISIONCONTACT] ([DECISIONCONTACTID]),
    CONSTRAINT [FK_DECISIONPAGE_DECISIONPARCEL] FOREIGN KEY ([DECISIONPARCELID]) REFERENCES [dbo].[DECISIONPARCEL] ([DECISIONPARCELID]),
    CONSTRAINT [FK_DECISIONPAGE_DECISIONPERMIT] FOREIGN KEY ([DECISIONPERMITID]) REFERENCES [dbo].[DECISIONPERMIT] ([DECISIONPERMITID]),
    CONSTRAINT [FK_DECISIONPAGE_DECISIONPLAN] FOREIGN KEY ([DECISIONPLANID]) REFERENCES [dbo].[DECISIONPLAN] ([DECISIONPLANID]),
    CONSTRAINT [FK_DECISIONPAGE_DECISIONPREFAB] FOREIGN KEY ([DECISIONPREFABID]) REFERENCES [dbo].[DECISIONPREFAB] ([DECISIONPREFABID]),
    CONSTRAINT [FK_DECISIONPAGE_DECISIONPREP] FOREIGN KEY ([DECISIONPREFPERMITID]) REFERENCES [dbo].[DECISIONPREFPERMIT] ([DECISIONPREFPERMITID]),
    CONSTRAINT [FK_DECISIONPAGE_DECISIONPROJE] FOREIGN KEY ([DECISIONPROJECTID]) REFERENCES [dbo].[DECISIONPROJECT] ([DECISIONPROJECTID]),
    CONSTRAINT [FK_DECISIONPAGE_DECREQUEST] FOREIGN KEY ([DECISIONREQUESTID]) REFERENCES [dbo].[DECISIONREQUEST] ([DECISIONREQUESTID]),
    CONSTRAINT [FK_DecisionPage_Parent] FOREIGN KEY ([PARENTDECISIONPAGEID]) REFERENCES [dbo].[DECISIONPAGE] ([DECISIONPAGEID]),
    CONSTRAINT [FK_DecisionPage_Type] FOREIGN KEY ([DECISIONPAGETYPEID]) REFERENCES [dbo].[DECISIONPAGETYPE] ([DECISIONPAGETYPEID]),
    CONSTRAINT [FK_Page_DecisionApp] FOREIGN KEY ([DECISIONAPPID]) REFERENCES [dbo].[DECISIONAPP] ([DECISIONAPPID]),
    CONSTRAINT [FK_Page_ParentQuest] FOREIGN KEY ([PARENTDECISIONQUESTIONNAIREID]) REFERENCES [dbo].[DECISIONQUESTIONNAIRE] ([DECISIONQUESTIONNAIREID]),
    CONSTRAINT [FK_Page_Questionnaire] FOREIGN KEY ([DECISIONQUESTIONNAIREID]) REFERENCES [dbo].[DECISIONQUESTIONNAIRE] ([DECISIONQUESTIONNAIREID])
);
