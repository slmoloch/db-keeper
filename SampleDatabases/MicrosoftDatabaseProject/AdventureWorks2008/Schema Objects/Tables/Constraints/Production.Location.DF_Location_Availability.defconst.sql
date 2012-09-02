ALTER TABLE [Production].[Location]
    ADD CONSTRAINT [DF_Location_Availability] DEFAULT ((0.00)) FOR [Availability];

