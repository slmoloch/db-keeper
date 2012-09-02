ALTER TABLE [Sales].[ShoppingCartItem]
    ADD CONSTRAINT [CK_ShoppingCartItem_Quantity] CHECK ([Quantity]>=(1));

