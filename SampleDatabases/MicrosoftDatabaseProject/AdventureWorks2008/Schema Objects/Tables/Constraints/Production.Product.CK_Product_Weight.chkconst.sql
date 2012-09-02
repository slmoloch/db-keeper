ALTER TABLE [Production].[Product]
    ADD CONSTRAINT [CK_Product_Weight] CHECK ([Weight]>(0.00));

