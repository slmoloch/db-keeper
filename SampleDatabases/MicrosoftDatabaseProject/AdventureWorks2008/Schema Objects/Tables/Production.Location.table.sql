CREATE TABLE [Production].[Location] (
    [LocationID]   SMALLINT       IDENTITY (1, 1) NOT NULL,
    [Name]         NVARCHAR (50)   NOT NULL,
    [CostRate]     SMALLMONEY     NOT NULL,
    [Availability] DECIMAL (8, 2) NOT NULL,
    [ModifiedDate] DATETIME       NOT NULL
);

