CREATE TABLE [Person].[StateProvince] (
    [StateProvinceID]         INT              IDENTITY (1, 1) NOT NULL,
    [StateProvinceCode]       NCHAR (3)        NOT NULL,
    [CountryRegionCode]       NVARCHAR (3)     NOT NULL,
    [IsOnlyStateProvinceFlag] [dbo].[Flag]     NOT NULL,
    [Name]                    NVARCHAR (50)     NOT NULL,
    [TerritoryID]             INT              NOT NULL,
    [rowguid]                 UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [ModifiedDate]            DATETIME         NOT NULL
);

