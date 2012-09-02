ALTER TABLE [Purchasing].[ShipMethod]
    ADD CONSTRAINT [DF_ShipMethod_rowguid] DEFAULT (newid()) FOR [rowguid];

