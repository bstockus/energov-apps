﻿CREATE TABLE [dbo].[CITIZENREQUESTALLOWEDACTIVITY] (
    [CITIZENREQUESTALLOWACTIVITYID] CHAR (36) NOT NULL,
    [CITIZENREQUESTTYPEID]          CHAR (36) NOT NULL,
    [CITIZENREQUESTACTIVITYTYPEID]  CHAR (36) NOT NULL,
    CONSTRAINT [PK_CitizenRequestAllowedActivity] PRIMARY KEY CLUSTERED ([CITIZENREQUESTALLOWACTIVITYID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_CitizenRequestAllowedActivity_CitizenRequestActivityType] FOREIGN KEY ([CITIZENREQUESTACTIVITYTYPEID]) REFERENCES [dbo].[CITIZENREQUESTACTIVITYTYPE] ([CITIZENREQUESTACTIVITYTYPEID]),
    CONSTRAINT [FK_CitizenRequestAllowedActivity_CitizenRequestType] FOREIGN KEY ([CITIZENREQUESTTYPEID]) REFERENCES [dbo].[CITIZENREQUESTTYPE] ([CITIZENREQUESTTYPEID])
);

