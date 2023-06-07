CREATE TABLE [dbo].[CITIZENREQUESTACTIVITYTYPE] (
    [CITIZENREQUESTACTIVITYTYPEID] CHAR (36)      NOT NULL,
    [NAME]                         NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]                  NVARCHAR (MAX) NULL,
    [CANEDIT]                      BIT            NULL,
    [CREATEID]                     BIT            NULL,
    [PREFIXID]                     NVARCHAR (20)  NULL,
    [ALLOWDUPLICATE]               BIT            NULL,
    [CUSTOMFIELDID]                CHAR (36)      NULL,
    CONSTRAINT [PK_CitizenRequestActivityType] PRIMARY KEY CLUSTERED ([CITIZENREQUESTACTIVITYTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_CitizenRequestActivityType_Custom] FOREIGN KEY ([CUSTOMFIELDID]) REFERENCES [dbo].[CUSTOMFIELDLAYOUT] ([GCUSTOMFIELDLAYOUTS])
);

