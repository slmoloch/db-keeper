ALTER TABLE [Sales].[ShoppingCartItem]
    ADD CONSTRAINT [DF_ShoppingCartItem_DateCreated] DEFAULT (getdate()) FOR [DateCreated];

