ALTER TABLE [Production].[TransactionHistory]
    ADD CONSTRAINT [DF_TransactionHistory_ReferenceOrderLineID] DEFAULT ((0)) FOR [ReferenceOrderLineID];

