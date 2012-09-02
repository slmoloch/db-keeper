ALTER TABLE [Purchasing].[ShipMethod]
    ADD CONSTRAINT [DF_ShipMethod_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

