ALTER TABLE [HumanResources].[Employee]
    ADD CONSTRAINT [DF_Employee_SalariedFlag] DEFAULT ((1)) FOR [SalariedFlag];

