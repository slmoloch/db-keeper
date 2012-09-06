CREATE TABLE [Sales].[SalesTaxRate] (
    [SalesTaxRateID]  INT              IDENTITY (1, 1) NOT NULL,
    [StateProvinceID] INT              NOT NULL,
    [TaxType]         TINYINT          NOT NULL,
    [TaxRate]         SMALLMONEY       NOT NULL,
    [Name]            NVARCHAR (50)     NOT NULL,
    [rowguid]         UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [ModifiedDate]    DATETIME         NOT NULL
);

