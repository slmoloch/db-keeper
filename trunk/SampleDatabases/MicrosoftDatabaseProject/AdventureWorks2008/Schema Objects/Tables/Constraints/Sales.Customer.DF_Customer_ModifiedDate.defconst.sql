ALTER TABLE [Sales].[Customer]
    ADD CONSTRAINT [DF_Customer_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

