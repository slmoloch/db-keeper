ALTER TABLE [Production].[TransactionHistoryArchive]
    ADD CONSTRAINT [DF_TransactionHistoryArchive_ReferenceOrderLineID] DEFAULT ((0)) FOR [ReferenceOrderLineID];

