CREATE TABLE [dbo].[FORMS] (
    [SFORMSGUID]              CHAR (36)      CONSTRAINT [DF_Forms_sFormsGUID] DEFAULT (newid()) NOT NULL,
    [FKSUBMENUGUID]           CHAR (36)      NULL,
    [SFORMNAME]               NVARCHAR (250) NULL,
    [SCOMMONNAME]             NVARCHAR (50)  NOT NULL,
    [SHINT]                   NVARCHAR (100) NULL,
    [IORDER]                  SMALLINT       CONSTRAINT [DF_Forms_iOrder] DEFAULT ((99)) NOT NULL,
    [BALLOWMULTIPLEINSTANCES] BIT            CONSTRAINT [DF_Forms_bAllowMultipleInstances] DEFAULT ((1)) NOT NULL,
    [ROOTCLASSNAME]           NVARCHAR (MAX) NULL,
    [MODULE_ID]               INT            DEFAULT ((1)) NOT NULL,
    [URL]                     NVARCHAR (255) NULL,
    [IS_HTML_ACTIVE]          BIT            NULL,
    [ICONPATH]                VARCHAR (255)  NULL,
    [HTML_COMMON_NAME]        NVARCHAR (50)  NULL,
    CONSTRAINT [PK_Forms] PRIMARY KEY CLUSTERED ([SFORMSGUID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Forms_SubMenus] FOREIGN KEY ([FKSUBMENUGUID]) REFERENCES [dbo].[SUBMENUS] ([SSUBMENUGUID])
);

