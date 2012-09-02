ALTER TABLE [Purchasing].[ShipMethod]
    ADD CONSTRAINT [DF_ShipMethod_ShipBase] DEFAULT ((0.00)) FOR [ShipBase];

