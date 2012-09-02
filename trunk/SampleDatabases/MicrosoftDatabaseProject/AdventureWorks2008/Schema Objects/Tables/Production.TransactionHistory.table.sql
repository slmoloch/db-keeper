CREATE TABLE [Production].[TransactionHistory] (
    [TransactionID]        INT       IDENTITY (100000, 1) NOT NULL,
    [ProductID]            INT       NOT NULL,
    [ReferenceOrderID]     INT       NOT NULL,
    [ReferenceOrderLineID] INT       NOT NULL,
    [TransactionDate]      DATETIME  NOT NULL,
    [TransactionType]      NCHAR (1) NOT NULL,
    [Quantity]             INT       NOT NULL,
    [ActualCost]           MONEY     NOT NULL,
    [ModifiedDate]         DATETIME  NOT NULL
);

