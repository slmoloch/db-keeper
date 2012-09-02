ALTER TABLE [Production].[TransactionHistory]
    ADD CONSTRAINT [DF_TransactionHistory_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

