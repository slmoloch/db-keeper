ALTER TABLE [Production].[Product]
    ADD CONSTRAINT [CK_Product_DaysToManufacture] CHECK ([DaysToManufacture]>=(0));

