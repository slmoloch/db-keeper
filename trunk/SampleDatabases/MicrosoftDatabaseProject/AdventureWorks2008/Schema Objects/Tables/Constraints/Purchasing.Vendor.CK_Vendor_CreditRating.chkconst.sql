ALTER TABLE [Purchasing].[Vendor]
    ADD CONSTRAINT [CK_Vendor_CreditRating] CHECK ([CreditRating]>=(1) AND [CreditRating]<=(5));

