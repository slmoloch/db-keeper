CREATE TABLE [Person].[BusinessEntityAddress] (
    [BusinessEntityID] INT              NOT NULL,
    [AddressID]        INT              NOT NULL,
    [AddressTypeID]    INT              NOT NULL,
    [rowguid]          UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [ModifiedDate]     DATETIME         NOT NULL
);

