ALTER TABLE [Production].[TransactionHistory]
    ADD CONSTRAINT [CK_TransactionHistory_TransactionType] CHECK (upper([TransactionType])='P' OR upper([TransactionType])='S' OR upper([TransactionType])='W');

