CREATE TABLE [Sales].[Customer] (
    [CustomerID]    INT              IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [PersonID]      INT              NULL,
    [StoreID]       INT              NULL,
    [TerritoryID]   INT              NULL,
    [AccountNumber] AS               (isnull('AW'+[dbo].[ufnLeadingZeros]([CustomerID]),'')),
    [rowguid]       UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [ModifiedDate]  DATETIME         NOT NULL
);

