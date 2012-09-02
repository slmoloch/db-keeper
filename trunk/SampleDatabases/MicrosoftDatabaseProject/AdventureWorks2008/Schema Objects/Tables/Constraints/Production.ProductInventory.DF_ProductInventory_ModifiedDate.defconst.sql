ALTER TABLE [Production].[ProductInventory]
    ADD CONSTRAINT [DF_ProductInventory_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

