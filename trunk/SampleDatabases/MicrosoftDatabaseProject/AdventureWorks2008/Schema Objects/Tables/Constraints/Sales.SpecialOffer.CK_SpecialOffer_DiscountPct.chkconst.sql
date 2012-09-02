ALTER TABLE [Sales].[SpecialOffer]
    ADD CONSTRAINT [CK_SpecialOffer_DiscountPct] CHECK ([DiscountPct]>=(0.00));

