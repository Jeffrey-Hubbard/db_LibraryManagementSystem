USE master
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Build_db_LibraryManagementSystem]
AS
BEGIN

	/******************************************************
	 * The following prevents any errors from occuring
	 * if the database or tables already exist.
	 * This code will close all active connections to the 
	 * database and then drop it
	 ******************************************************/

	WHILE EXISTS(select * from sys.databases where name='db_LibraryManagementSystem')
	BEGIN
		DECLARE @SQL varchar(max)
		SELECT @SQL = COALESCE(@SQL,'') + 'Kill ' + Convert(varchar, SPId) + ';'
		FROM MASTER.sys.sysprocesses
		WHERE DBId = DB_ID(N'db_LibraryManagementSystem') AND SPId <> @@SPId
		EXEC(@SQL)
		DROP DATABASE [db_LibraryManagementSystem]
	END
	/******************************************************
	 * The following demonstrates a stored proceedure to 
	 * build the database, tables and then populate the 
	 * tables with data.
	 ******************************************************/

	-- Create the database
	CREATE DATABASE db_LibraryManagementSystem

END

GO


