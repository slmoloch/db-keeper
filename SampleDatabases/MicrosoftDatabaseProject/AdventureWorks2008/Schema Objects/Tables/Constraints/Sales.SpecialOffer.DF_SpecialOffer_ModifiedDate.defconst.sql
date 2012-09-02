ALTER TABLE [Sales].[SpecialOffer]
    ADD CONSTRAINT [DF_SpecialOffer_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

