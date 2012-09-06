CREATE TABLE [Person].[AddressType] (
    [AddressTypeID] INT              IDENTITY (1, 1) NOT NULL,
    [Name]          NVARCHAR (50)     NOT NULL,
    [rowguid]       UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [ModifiedDate]  DATETIME         NOT NULL
);

