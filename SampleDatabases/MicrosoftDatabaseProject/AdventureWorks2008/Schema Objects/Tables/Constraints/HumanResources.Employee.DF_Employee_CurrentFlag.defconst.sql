ALTER TABLE [HumanResources].[Employee]
    ADD CONSTRAINT [DF_Employee_CurrentFlag] DEFAULT ((1)) FOR [CurrentFlag];

