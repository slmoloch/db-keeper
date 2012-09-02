ALTER TABLE [HumanResources].[Employee]
    ADD CONSTRAINT [DF_Employee_rowguid] DEFAULT (newid()) FOR [rowguid];

