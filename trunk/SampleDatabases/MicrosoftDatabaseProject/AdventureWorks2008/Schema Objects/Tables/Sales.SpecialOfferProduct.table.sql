CREATE TABLE [Sales].[SpecialOfferProduct] (
    [SpecialOfferID] INT              NOT NULL,
    [ProductID]      INT              NOT NULL,
    [rowguid]        UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [ModifiedDate]   DATETIME         NOT NULL
);

