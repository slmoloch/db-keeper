ALTER TABLE [Sales].[SpecialOffer]
    ADD CONSTRAINT [CK_SpecialOffer_MaxQty] CHECK ([MaxQty]>=(0));

