ALTER TABLE [Production].[ProductInventory]
    ADD CONSTRAINT [DF_ProductInventory_rowguid] DEFAULT (newid()) FOR [rowguid];

