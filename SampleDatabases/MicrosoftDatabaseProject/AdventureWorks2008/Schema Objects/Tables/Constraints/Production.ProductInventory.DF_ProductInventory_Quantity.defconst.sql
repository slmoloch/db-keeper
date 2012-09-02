ALTER TABLE [Production].[ProductInventory]
    ADD CONSTRAINT [DF_ProductInventory_Quantity] DEFAULT ((0)) FOR [Quantity];

