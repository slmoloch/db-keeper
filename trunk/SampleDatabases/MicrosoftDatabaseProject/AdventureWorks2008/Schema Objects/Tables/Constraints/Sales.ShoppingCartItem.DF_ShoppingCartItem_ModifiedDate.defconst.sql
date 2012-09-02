ALTER TABLE [Sales].[ShoppingCartItem]
    ADD CONSTRAINT [DF_ShoppingCartItem_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

