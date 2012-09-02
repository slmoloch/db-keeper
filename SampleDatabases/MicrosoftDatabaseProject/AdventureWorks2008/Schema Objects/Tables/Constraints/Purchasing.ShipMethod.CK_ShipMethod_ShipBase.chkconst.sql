ALTER TABLE [Purchasing].[ShipMethod]
    ADD CONSTRAINT [CK_ShipMethod_ShipBase] CHECK ([ShipBase]>(0.00));

