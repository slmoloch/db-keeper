ALTER TABLE [Purchasing].[Vendor]
    ADD CONSTRAINT [DF_Vendor_ActiveFlag] DEFAULT ((1)) FOR [ActiveFlag];

