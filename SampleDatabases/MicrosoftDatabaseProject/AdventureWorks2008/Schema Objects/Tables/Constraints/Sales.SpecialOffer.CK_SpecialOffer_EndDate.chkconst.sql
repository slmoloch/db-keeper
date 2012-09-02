ALTER TABLE [Sales].[SpecialOffer]
    ADD CONSTRAINT [CK_SpecialOffer_EndDate] CHECK ([EndDate]>=[StartDate]);

