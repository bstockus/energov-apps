﻿CREATE TABLE [dbo].[AMWORKORDEREQUIPMENT] (
    [AMWORKORDEREQUIPMENTID] CHAR (36)       NOT NULL,
    [AMWORKORDERID]          CHAR (36)       NOT NULL,
    [AMEQUIPMENTID]          CHAR (36)       NOT NULL,
    [TIMEPLANNED]            DECIMAL (18, 2) NULL,
    [TIMEACTUAL]             DECIMAL (18, 2) NULL,
    [RATE]                   MONEY           NULL,
    [TIMEUOM]                CHAR (36)       NULL,
    [STARTDATE]              DATETIME        NULL,
    [ENDDATE]                DATETIME        NULL,
    CONSTRAINT [PK_AMWorkOrderEquipment] PRIMARY KEY CLUSTERED ([AMWORKORDEREQUIPMENTID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AMWOEquipment_AMEquipment] FOREIGN KEY ([AMEQUIPMENTID]) REFERENCES [dbo].[AMEQUIPMENT] ([AMEQUIPMENTID]),
    CONSTRAINT [FK_AMWOEquipment_AMWorkOrder] FOREIGN KEY ([AMWORKORDERID]) REFERENCES [dbo].[AMWORKORDER] ([AMWORKORDERID]),
    CONSTRAINT [FK_AMWOEquipment_UnitOfMeasure] FOREIGN KEY ([TIMEUOM]) REFERENCES [dbo].[UNITOFMEASURE] ([UNITOFMEASUREID])
);
