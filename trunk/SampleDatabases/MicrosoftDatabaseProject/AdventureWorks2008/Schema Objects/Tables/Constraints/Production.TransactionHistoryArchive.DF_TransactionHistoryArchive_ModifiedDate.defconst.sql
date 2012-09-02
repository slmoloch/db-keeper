ALTER TABLE [Production].[TransactionHistoryArchive]
    ADD CONSTRAINT [DF_TransactionHistoryArchive_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

