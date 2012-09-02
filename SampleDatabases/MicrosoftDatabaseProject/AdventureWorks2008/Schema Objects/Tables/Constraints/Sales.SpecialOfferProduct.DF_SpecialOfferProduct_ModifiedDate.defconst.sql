ALTER TABLE [Sales].[SpecialOfferProduct]
    ADD CONSTRAINT [DF_SpecialOfferProduct_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

