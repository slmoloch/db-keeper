ALTER TABLE [Sales].[Store]
    ADD CONSTRAINT [DF_Store_rowguid] DEFAULT (newid()) FOR [rowguid];

