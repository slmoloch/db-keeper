ALTER TABLE [HumanResources].[Employee]
    ADD CONSTRAINT [DF_Employee_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

