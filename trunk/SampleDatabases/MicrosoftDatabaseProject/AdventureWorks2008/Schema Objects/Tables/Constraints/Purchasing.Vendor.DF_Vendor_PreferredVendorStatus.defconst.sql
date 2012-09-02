ALTER TABLE [Purchasing].[Vendor]
    ADD CONSTRAINT [DF_Vendor_PreferredVendorStatus] DEFAULT ((1)) FOR [PreferredVendorStatus];

