CREATE TABLE [Purchasing].[ShipMethod] (
    [ShipMethodID] INT              IDENTITY (1, 1) NOT NULL,
    [Name]         NVARCHAR (50)     NOT NULL,
    [ShipBase]     MONEY            NOT NULL,
    [ShipRate]     MONEY            NOT NULL,
    [rowguid]      UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [ModifiedDate] DATETIME         NOT NULL
);

