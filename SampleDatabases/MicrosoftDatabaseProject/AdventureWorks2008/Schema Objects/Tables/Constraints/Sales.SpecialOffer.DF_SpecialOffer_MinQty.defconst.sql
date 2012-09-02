ALTER TABLE [Sales].[SpecialOffer]
    ADD CONSTRAINT [DF_SpecialOffer_MinQty] DEFAULT ((0)) FOR [MinQty];

