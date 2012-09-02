ALTER TABLE [Purchasing].[ShipMethod]
    ADD CONSTRAINT [DF_ShipMethod_ShipRate] DEFAULT ((0.00)) FOR [ShipRate];

