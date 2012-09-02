CREATE TABLE [Sales].[Store] (
    [BusinessEntityID] INT                                                NOT NULL,
    [Name]             [dbo].[Name]                                       NOT NULL,
    [SalesPersonID]    INT                                                NULL,
    [Demographics]     XML(CONTENT [Sales].[StoreSurveySchemaCollection]) NULL,
    [rowguid]          UNIQUEIDENTIFIER                                   ROWGUIDCOL NOT NULL,
    [ModifiedDate]     DATETIME                                           NOT NULL
);

