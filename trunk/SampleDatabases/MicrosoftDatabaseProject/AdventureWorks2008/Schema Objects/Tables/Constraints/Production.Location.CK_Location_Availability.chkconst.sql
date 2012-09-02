ALTER TABLE [Production].[Location]
    ADD CONSTRAINT [CK_Location_Availability] CHECK ([Availability]>=(0.00));

