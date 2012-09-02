ALTER TABLE [HumanResources].[Employee]
    ADD CONSTRAINT [DF_Employee_VacationHours] DEFAULT ((0)) FOR [VacationHours];

