﻿CREATE TABLE [dbo].[CITIZENREQUESTPARCEL] (
    [CITIZENREQUESTPARCELID] CHAR (36) NOT NULL,
    [PARCELID]               CHAR (36) NOT NULL,
    [CITIZENREQUESTID]       CHAR (36) NOT NULL,
    [MAIN]                   BIT       NOT NULL,
    CONSTRAINT [PK_CitizenRequestParcel] PRIMARY KEY CLUSTERED ([CITIZENREQUESTPARCELID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_CitizenRequestParcel_CitizenRequest] FOREIGN KEY ([CITIZENREQUESTID]) REFERENCES [dbo].[CITIZENREQUEST] ([CITIZENREQUESTID]),
    CONSTRAINT [FK_CitizenRequestParcel_Parcel] FOREIGN KEY ([PARCELID]) REFERENCES [dbo].[PARCEL] ([PARCELID])
);


GO
CREATE NONCLUSTERED INDEX [IMPORT1]
    ON [dbo].[CITIZENREQUESTPARCEL]([CITIZENREQUESTID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IMPORT2]
    ON [dbo].[CITIZENREQUESTPARCEL]([PARCELID] ASC) WITH (FILLFACTOR = 80);
