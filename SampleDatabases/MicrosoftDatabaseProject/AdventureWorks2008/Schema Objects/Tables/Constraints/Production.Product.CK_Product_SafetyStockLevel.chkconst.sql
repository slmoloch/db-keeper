ALTER TABLE [Production].[Product]
    ADD CONSTRAINT [CK_Product_SafetyStockLevel] CHECK ([SafetyStockLevel]>(0));

