CREATE TABLE [Person].[Password] (
    [BusinessEntityID] INT              NOT NULL,
    [PasswordHash]     VARCHAR (128)    NOT NULL,
    [PasswordSalt]     VARCHAR (10)     NOT NULL,
    [rowguid]          UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [ModifiedDate]     DATETIME         NOT NULL
);

