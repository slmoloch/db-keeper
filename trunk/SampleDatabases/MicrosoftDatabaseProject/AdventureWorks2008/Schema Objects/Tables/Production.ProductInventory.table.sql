CREATE TABLE [Production].[ProductInventory] (
    [ProductID]    INT              NOT NULL,
    [LocationID]   SMALLINT         NOT NULL,
    [Shelf]        NVARCHAR (10)    NOT NULL,
    [Bin]          TINYINT          NOT NULL,
    [Quantity]     SMALLINT         NOT NULL,
    [rowguid]      UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [ModifiedDate] DATETIME         NOT NULL
);

