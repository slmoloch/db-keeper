ALTER TABLE [Production].[Product]
    ADD CONSTRAINT [CK_Product_Style] CHECK (upper([Style])='U' OR upper([Style])='M' OR upper([Style])='W' OR [Style] IS NULL);

