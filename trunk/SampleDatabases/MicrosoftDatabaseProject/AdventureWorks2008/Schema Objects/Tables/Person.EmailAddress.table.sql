CREATE TABLE [Person].[EmailAddress] (
    [BusinessEntityID] INT              NOT NULL,
    [EmailAddressID]   INT              IDENTITY (1, 1) NOT NULL,
    [EmailAddress]     NVARCHAR (50)    NULL,
    [rowguid]          UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [ModifiedDate]     DATETIME         NOT NULL
);

