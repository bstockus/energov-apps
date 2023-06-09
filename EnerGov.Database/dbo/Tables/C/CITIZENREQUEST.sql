﻿CREATE TABLE [dbo].[CITIZENREQUEST] (
    [CITIZENREQUESTID]          CHAR (36)      CONSTRAINT [DF_CitizenRequests_gID] DEFAULT ((0)) NOT NULL,
    [REQUESTNUMBER]             NVARCHAR (50)  NOT NULL,
    [IDREQUESTNUMBER]           NUMERIC (18)   NOT NULL,
    [CITIZENREQUESTTYPEID]      CHAR (36)      NOT NULL,
    [COMMENTS]                  NVARCHAR (MAX) NULL,
    [DESCRIPTION]               NVARCHAR (MAX) NULL,
    [REVIEWED]                  BIT            NULL,
    [DATEFILED]                 DATETIME       NULL,
    [CITIZENREQUESTSTATUSID]    CHAR (36)      NULL,
    [CITIZENREQUESTPRIORITYID]  CHAR (36)      NULL,
    [ENTEREDBYUSER]             CHAR (36)      NULL,
    [ASSIGNEDTOUSER]            CHAR (36)      NULL,
    [COMPDEADLINE]              DATETIME       NULL,
    [COMPCOMPLETE]              DATETIME       NULL,
    [EMERGENCY]                 BIT            NULL,
    [RESOLVED]                  BIT            NULL,
    [ROWVERSION]                INT            NOT NULL,
    [LASTCHANGEDON]             DATETIME       NULL,
    [LASTCHANGEDBY]             CHAR (36)      NULL,
    [DISTRICTID]                CHAR (36)      NULL,
    [CITIZENREQUESTSOURCEID]    CHAR (36)      NULL,
    [IMPORTCUSTOMFIELDLAYOUTID] CHAR (36)      NULL,
    [ISAPPLIEDONLINE]           BIT            DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CitizenRequests] PRIMARY KEY CLUSTERED ([CITIZENREQUESTID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_CitizenRequest_CitizenRequestSource] FOREIGN KEY ([CITIZENREQUESTSOURCEID]) REFERENCES [dbo].[CITIZENREQUESTSOURCE] ([CITIZENREQUESTSOURCEID]),
    CONSTRAINT [FK_CitizenRequest_CRPriority] FOREIGN KEY ([CITIZENREQUESTPRIORITYID]) REFERENCES [dbo].[CITIZENREQUESTPRIORITY] ([CITIZENREQUESTPRIORITYID]),
    CONSTRAINT [FK_CitizenRequest_CRStatus] FOREIGN KEY ([CITIZENREQUESTSTATUSID]) REFERENCES [dbo].[CITIZENREQUESTSTATUS] ([CITIZENREQUESTSTATUSID]),
    CONSTRAINT [FK_CitizenRequest_CRType] FOREIGN KEY ([CITIZENREQUESTTYPEID]) REFERENCES [dbo].[CITIZENREQUESTTYPE] ([CITIZENREQUESTTYPEID]),
    CONSTRAINT [FK_CitizenRequest_CustomField] FOREIGN KEY ([IMPORTCUSTOMFIELDLAYOUTID]) REFERENCES [dbo].[CUSTOMFIELDLAYOUT] ([GCUSTOMFIELDLAYOUTS]),
    CONSTRAINT [FK_CitizenRequest_Users] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_CitizenRequest_Users1] FOREIGN KEY ([ASSIGNEDTOUSER]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_CitizenRequest_Users2] FOREIGN KEY ([ENTEREDBYUSER]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_Request_District] FOREIGN KEY ([DISTRICTID]) REFERENCES [dbo].[DISTRICT] ([DISTRICTID])
);


GO
CREATE NONCLUSTERED INDEX [IX_CITIZENREQUEST_ASSIGNTO]
    ON [dbo].[CITIZENREQUEST]([ASSIGNEDTOUSER] ASC, [COMPDEADLINE] ASC)
    INCLUDE([CITIZENREQUESTID], [REQUESTNUMBER], [IDREQUESTNUMBER], [CITIZENREQUESTTYPEID], [DESCRIPTION], [REVIEWED], [DATEFILED], [CITIZENREQUESTSTATUSID], [CITIZENREQUESTPRIORITYID], [ENTEREDBYUSER], [COMPCOMPLETE], [EMERGENCY], [RESOLVED], [ROWVERSION], [DISTRICTID], [CITIZENREQUESTSOURCEID]);


GO
CREATE NONCLUSTERED INDEX [IX_CITIZENREQUEST_LASTCHANGEDON]
    ON [dbo].[CITIZENREQUEST]([LASTCHANGEDON] ASC)
    INCLUDE([CITIZENREQUESTID]);


GO

CREATE TRIGGER [TG_CITIZENREQUEST_DELETE_ELASTIC] ON  CITIZENREQUEST
   AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;

    INSERT INTO [ELASTICSEARCHOBJECT]
    ( [ELASTICSEARCHOBJECTID] ,
        [OBJECTID] ,
        [OBJECTCLASSNAME] ,
        [ROWVERSION] ,
        [CREATEDATE] ,
        [PROCESSEDDATE] ,
        [OBJECTACTION] ,
        [INDEXNAME]
    )
	SELECT
		NEWID() ,
		[Deleted].[CITIZENREQUESTID] ,
        'EnerGovBusiness.CitizenRequest.Requestmgmt' ,
        [Deleted].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        3 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Deleted];

END
GO

CREATE TRIGGER [TG_CITIZENREQUEST_INSERT_ELASTIC] ON  CITIZENREQUEST
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

    INSERT INTO [ELASTICSEARCHOBJECT]
    ( [ELASTICSEARCHOBJECTID] ,
        [OBJECTID] ,
        [OBJECTCLASSNAME] ,
        [ROWVERSION] ,
        [CREATEDATE] ,
        [PROCESSEDDATE] ,
        [OBJECTACTION] ,
        [INDEXNAME]
    )
	SELECT
		NEWID() ,
		[Inserted].[CITIZENREQUESTID] ,
        'EnerGovBusiness.CitizenRequest.Requestmgmt' ,
        [Inserted].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        1 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted];

END
GO

CREATE TRIGGER [TG_CITIZENREQUEST_UPDATE_ELASTIC] ON  CITIZENREQUEST
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

    INSERT INTO [ELASTICSEARCHOBJECT]
    ( [ELASTICSEARCHOBJECTID] ,
        [OBJECTID] ,
        [OBJECTCLASSNAME] ,
        [ROWVERSION] ,
        [CREATEDATE] ,
        [PROCESSEDDATE] ,
        [OBJECTACTION] ,
        [INDEXNAME]
    )
	SELECT
		NEWID() ,
		[Inserted].[CITIZENREQUESTID] ,
        'EnerGovBusiness.CitizenRequest.Requestmgmt' ,
        [Inserted].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        2 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted];

END