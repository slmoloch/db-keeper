ALTER TABLE [Sales].[Customer]
    ADD CONSTRAINT [DF_Customer_rowguid] DEFAULT (newid()) FOR [rowguid];

