ALTER TABLE [Purchasing].[ShipMethod]
    ADD CONSTRAINT [CK_ShipMethod_ShipRate] CHECK ([ShipRate]>(0.00));

