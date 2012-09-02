ALTER TABLE [Production].[ProductListPriceHistory]
    ADD CONSTRAINT [CK_ProductListPriceHistory_ListPrice] CHECK ([ListPrice]>(0.00));

