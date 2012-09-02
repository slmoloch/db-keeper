CREATE TABLE [Production].[ProductCategory] (
    [ProductCategoryID] INT              IDENTITY (1, 1) NOT NULL,
    [Name]              [dbo].[Name]     NOT NULL,
    [rowguid]           UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [ModifiedDate]      DATETIME         NOT NULL
);

