ALTER TABLE [Production].[Location]
    ADD CONSTRAINT [DF_Location_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

