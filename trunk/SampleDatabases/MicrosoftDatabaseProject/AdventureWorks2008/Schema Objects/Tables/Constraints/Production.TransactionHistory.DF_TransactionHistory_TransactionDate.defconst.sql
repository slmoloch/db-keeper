ALTER TABLE [Production].[TransactionHistory]
    ADD CONSTRAINT [DF_TransactionHistory_TransactionDate] DEFAULT (getdate()) FOR [TransactionDate];

