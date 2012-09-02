CREATE TABLE [Production].[ProductCostHistory] (
    [ProductID]    INT      NOT NULL,
    [StartDate]    DATETIME NOT NULL,
    [EndDate]      DATETIME NULL,
    [StandardCost] MONEY    NOT NULL,
    [ModifiedDate] DATETIME NOT NULL
);

