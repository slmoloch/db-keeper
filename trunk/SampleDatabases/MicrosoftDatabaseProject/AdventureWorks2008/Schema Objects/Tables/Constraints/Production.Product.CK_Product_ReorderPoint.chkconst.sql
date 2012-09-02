ALTER TABLE [Production].[Product]
    ADD CONSTRAINT [CK_Product_ReorderPoint] CHECK ([ReorderPoint]>(0));

