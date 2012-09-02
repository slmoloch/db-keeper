﻿CREATE TABLE [Purchasing].[PurchaseOrderDetail] (
    [PurchaseOrderID]       INT            NOT NULL,
    [PurchaseOrderDetailID] INT            IDENTITY (1, 1) NOT NULL,
    [DueDate]               DATETIME       NOT NULL,
    [OrderQty]              SMALLINT       NOT NULL,
    [ProductID]             INT            NOT NULL,
    [UnitPrice]             MONEY          NOT NULL,
    [LineTotal]             AS             (isnull([OrderQty]*[UnitPrice],(0.00))),
    [ReceivedQty]           DECIMAL (8, 2) NOT NULL,
    [RejectedQty]           DECIMAL (8, 2) NOT NULL,
    [StockedQty]            AS             (isnull([ReceivedQty]-[RejectedQty],(0.00))),
    [ModifiedDate]          DATETIME       NOT NULL
);

