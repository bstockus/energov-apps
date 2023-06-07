CREATE TABLE [dbo].[GovolutionPaymentInfo] (
    [GovolutionPaymentInfoId] CHAR (36)      NOT NULL,
    [RemittanceId]            CHAR (30)      NOT NULL,
    [ApplicationId]           VARCHAR (50)   NOT NULL,
    [Messageversion]          VARCHAR (50)   NOT NULL,
    [FeeDescription]          VARCHAR (MAX)  NOT NULL,
    [InvoiceNumber]           VARCHAR (500)  NOT NULL,
    [InvoiceId]               CHAR (36)      NOT NULL,
    [SecurityId]              CHAR (32)      NOT NULL,
    [TimeStamp]               DATETIME       NOT NULL,
    [Amount]                  MONEY          NOT NULL,
    [Paid]                    BIT            NOT NULL,
    [PaymentMethod]           NVARCHAR (50)  NULL,
    [AuthCode]                NVARCHAR (50)  NULL,
    [RemittanceInfo]          NVARCHAR (100) NULL,
    [Processed]               BIT            NULL,
    CONSTRAINT [PK_GovolutionPaymentInfo] PRIMARY KEY CLUSTERED ([GovolutionPaymentInfoId] ASC) WITH (FILLFACTOR = 90)
);

