ALTER TABLE [Production].[ProductInventory]
    ADD CONSTRAINT [CK_ProductInventory_Shelf] CHECK ([Shelf] like '[A-Za-z]' OR [Shelf]='N/A');

