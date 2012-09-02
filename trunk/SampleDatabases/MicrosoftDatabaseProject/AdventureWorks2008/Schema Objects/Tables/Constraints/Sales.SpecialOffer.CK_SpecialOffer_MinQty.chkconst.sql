ALTER TABLE [Sales].[SpecialOffer]
    ADD CONSTRAINT [CK_SpecialOffer_MinQty] CHECK ([MinQty]>=(0));

