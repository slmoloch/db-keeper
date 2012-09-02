ALTER TABLE [Purchasing].[Vendor]
    ADD CONSTRAINT [DF_Vendor_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

