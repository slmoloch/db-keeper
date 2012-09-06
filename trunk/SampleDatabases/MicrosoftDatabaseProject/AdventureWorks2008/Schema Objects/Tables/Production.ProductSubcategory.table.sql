CREATE TABLE [Production].[ProductSubcategory] (
    [ProductSubcategoryID] INT              IDENTITY (1, 1) NOT NULL,
    [ProductCategoryID]    INT              NOT NULL,
    [Name]                 NVARCHAR (50)     NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [ModifiedDate]         DATETIME         NOT NULL
);

