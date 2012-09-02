ALTER TABLE [Production].[TransactionHistoryArchive]
    ADD CONSTRAINT [DF_TransactionHistoryArchive_TransactionDate] DEFAULT (getdate()) FOR [TransactionDate];

