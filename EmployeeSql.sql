USE [master]
GO
/****** Object:  Database [testB]    Script Date: 04/04/2024 10:37:26 ******/
CREATE DATABASE [testA]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'testB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\testB.mdf' , SIZE = 3136KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'testB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\testB_log.ldf' , SIZE = 784KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [testB] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [testB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [testB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [testB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [testB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [testB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [testB] SET ARITHABORT OFF 
GO
ALTER DATABASE [testB] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [testB] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [testB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [testB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [testB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [testB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [testB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [testB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [testB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [testB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [testB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [testB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [testB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [testB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [testB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [testB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [testB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [testB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [testB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [testB] SET  MULTI_USER 
GO
ALTER DATABASE [testB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [testB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [testB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [testB] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [testB]
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteEmployee]    Script Date: 04/04/2024 10:37:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_DeleteEmployee]
(
@Id int
)
as
begin
Delete from Employee where ID=@Id
end

GO
/****** Object:  StoredProcedure [dbo].[sp_Get_Employee_Details]    Script Date: 04/04/2024 10:37:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_Get_Employee_Details]
@Offset INT,
@PageSize INT,
@SearchKeyword NVARCHAR(100)
AS
BEGIN
    DECLARE @TotalRecords INT;

    BEGIN TRY
        SELECT @TotalRecords = COUNT(*)
        FROM Employee 
        --WHERE (@SearchKeyword IS NULL OR ED.ED_NAME LIKE '%' + @SearchKeyword + '%');
		
		--IF(@SearchKeyword = '')
		--BEGIN
		--	SELECT @TotalRecords AS TotalRecords, ED_ID, ED_NAME, ED_EMAIL, CONVERT(VARCHAR, ED_DOB, 105) as ED_DOB, 
		--	ED_ELM_EXP_LEVEL_ID, ELM_LEVEL_NAME, 
		--	ED_MG_GENDER_ID, MG_GENDER_NAME, ED_ADDRESS 
		--	FROM TBL_EMPLOYEE_DETAILS ED
		--	LEFT JOIN TBL_EXP_LEVEL_MASTER ELM ON ED.ED_ELM_EXP_LEVEL_ID = ELM.ELM_EXP_LEVEL_ID
		--	LEFT JOIN TBL_MASTER_GENDER MG ON ED.ED_MG_GENDER_ID = MG.MG_GENDER_ID
		--	WHERE (@SearchKeyword IS NULL OR ED.ED_NAME LIKE '%' + @SearchKeyword + '%')
		--	ORDER BY ED_ID
		--	OFFSET @Offset ROWS
		--	FETCH NEXT @PageSize ROWS ONLY;
		--END
		--ELSE

		BEGIN
			SELECT @TotalRecords AS TotalRecords, ID, NAME, Email, CONVERT(VARCHAR, DateOfBirth, 105) as DateOfBirth,picture
			FROM Employee ED
		    WHERE (@SearchKeyword IS NULL OR NAME LIKE '%' + @SearchKeyword + '%')
			ORDER BY ID DESC
			OFFSET @Offset ROWS
			FETCH NEXT @PageSize ROWS ONLY; 
		END


    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[sp_InsertupdateEmployee]    Script Date: 04/04/2024 10:37:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_InsertupdateEmployee]
(
@Id int,
@Name nvarchar(200),
@DateOfBirth datetime,
@Email nvarchar(200),
@Picture nvarchar(200)
)
as
begin
	begin try
	IF(@Id=0)
	begin
	insert into Employee(Name,DateOfBirth,Email,picture)values(@Name,@DateOfBirth,@Email,@Picture)
	SELECT 201 AS MESSAGECODE, 'Employee Details Saved Successfully..!' AS MESSAGE;
	end
	else
	begin
	update Employee
	set Name=@Name,DateOfBirth=@DateOfBirth,Email=@Email,picture=@Picture
	where ID=@Id
	SELECT 200 AS MESSAGECODE, 'Employee Details Updated Successfully..!' AS MESSAGE;
	end
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
	end
GO
/****** Object:  StoredProcedure [dbo].[sp_SelectEmployee]    Script Date: 04/04/2024 10:37:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_SelectEmployee]
as
begin
select * from Employee
end 

GO
/****** Object:  Table [dbo].[Employee]    Script Date: 04/04/2024 10:37:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NULL,
	[DateOfBirth] [datetime] NULL,
	[Email] [nvarchar](200) NULL,
	[picture] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
USE [master]
GO
ALTER DATABASE [testB] SET  READ_WRITE 
GO
