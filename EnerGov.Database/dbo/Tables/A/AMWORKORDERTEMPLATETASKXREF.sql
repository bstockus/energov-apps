﻿CREATE TABLE [dbo].[AMWORKORDERTEMPLATETASKXREF] (
    [AMWORKORDERTEMPLATETASKXREFID] CHAR (36) NOT NULL,
    [AMWORKORDERTEMPLATEID]         CHAR (36) NOT NULL,
    [AMTASKID]                      CHAR (36) NOT NULL,
    [SORTORDER]                     INT       CONSTRAINT [DF_AMWorkOrderTemplateTask_Order] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_AMWorkOrderTemplateTask] PRIMARY KEY NONCLUSTERED ([AMWORKORDERTEMPLATETASKXREFID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AMWorkOrderTemplateTaskXRef] FOREIGN KEY ([AMTASKID]) REFERENCES [dbo].[AMTASK] ([AMTASKID]),
    CONSTRAINT [FK_OrderTemplateTX_Tmpl] FOREIGN KEY ([AMWORKORDERTEMPLATEID]) REFERENCES [dbo].[AMWORKORDERTEMPLATE] ([AMWORKORDERTEMPLATEID])
);


GO
CREATE NONCLUSTERED INDEX [IX_OrderTemplateTaskXRef_Task]
    ON [dbo].[AMWORKORDERTEMPLATETASKXREF]([AMTASKID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_OrderTemplateTaskXRef_Tmpl]
    ON [dbo].[AMWORKORDERTEMPLATETASKXREF]([AMWORKORDERTEMPLATEID] ASC) WITH (FILLFACTOR = 90);

