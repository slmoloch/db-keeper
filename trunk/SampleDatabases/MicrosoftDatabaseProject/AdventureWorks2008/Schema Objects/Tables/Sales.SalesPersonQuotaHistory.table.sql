CREATE TABLE [Sales].[SalesPersonQuotaHistory] (
    [BusinessEntityID] INT              NOT NULL,
    [QuotaDate]        DATETIME         NOT NULL,
    [SalesQuota]       MONEY            NOT NULL,
    [rowguid]          UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [ModifiedDate]     DATETIME         NOT NULL
);

