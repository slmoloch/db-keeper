ALTER DATABASE [$(DatabaseName)]
    ADD FILE (NAME = [AdventureWorks2008_Data], FILENAME = '$(DefaultDataPath)$(DatabaseName)_Data.mdf', FILEGROWTH = 8192 KB) TO FILEGROUP [PRIMARY];

