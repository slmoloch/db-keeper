ALTER TABLE [Sales].[SpecialOffer]
    ADD CONSTRAINT [DF_SpecialOffer_DiscountPct] DEFAULT ((0.00)) FOR [DiscountPct];

