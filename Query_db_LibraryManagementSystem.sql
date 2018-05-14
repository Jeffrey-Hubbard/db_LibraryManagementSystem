USE [db_LibraryManagementSystem]
GO
/****** Object:  StoredProcedure [dbo].[Query_db_LibraryManagementSystem]    Script Date: 5/14/18 1:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Query_db_LibraryManagementSystem]
AS
BEGIN
	-- First, we will find the number of copies of ''The Lost Tribe'' at the Library Branch ''Sharpstown''.'
	SELECT t1.NumberOfCopies AS 'Number of Copies'
	FROM tbl_BookCopies t1
		INNER JOIN tbl_Book t2 ON t2.BookID = t1.BookID
		INNER JOIN tbl_LibraryBranch t3 ON t3.BranchID = t1.BranchID
	WHERE  t3.BranchName = 'Sharpstown' AND t2.Title = 'The Lost Tribe'
	;

	--Second, we will find the number of copies of the book titled ''The Lost Tribe'' at each library branch
	SELECT
		t2.BranchName AS 'Branch Name',
		t1.NumberOfCopies AS 'Number of Copies'
	FROM tbl_BookCopies t1
		INNER JOIN tbl_LibraryBranch t2 ON t2.BranchID = t1.BranchID
		INNER JOIN tbl_Book t3 ON t3.BookID = t1.BookID
	WHERE t3.Title = 'The Lost Tribe'
	;

	--Third, we will retrieve the names of all borrowers who do not have any books checked out
	SELECT
		t1.BorrowerName
	FROM tbl_Borrower t1
		LEFT JOIN tbl_BookLoans t2 ON t2.CardNumber = t1.CardNumber
	WHERE t2.CardNumber IS NULL
	;

	/*	Fourth, for each book that is loaned out from the Sharpstown 
		branch whose due date is today, retrieve the book title, 
		borrower's name, and borrower's address */
	SELECT
		t1.Title AS 'Book Title', 
		t4.BorrowerName AS 'Borrower''s Name', 
		t4.BorrowerAddress AS 'Borrower''s Address'
	FROM tbl_Book t1
		INNER JOIN tbl_BookLoans t2 ON t2.BookID = t1.BookID
		INNER JOIN tbl_LibraryBranch t3 ON t3.BranchID = t2.BranchID
		INNER JOIN tbl_Borrower t4 ON t4.CardNumber = t2.CardNumber
	WHERE t3.BranchName = 'Sharpstown' AND t2.DateDue = CAST(GETDATE() AS date)
	;

	/*	Fifth, for each library branch, we will retrieve the 
		Branch name and total number of books loaned out from
		that branch. */
	SELECT 
		t1.BranchName AS 'Branch Name',
		COUNT(t1.BranchName) AS 'Total Loaned Books'
	FROM tbl_LibraryBranch t1
		INNER JOIN tbl_BookLoans t2 ON t2.BranchID = t1.BranchID
	GROUP BY t1.BranchName
	;

	/*	Sixth, retrieve the names, addresses, and number of books checked out
		for all borrowers who have more than 5 books checked out */
	SELECT 
		t1.BorrowerName AS 'Borrower Name',
		t1.BorrowerAddress AS 'Borrower Address',
		COUNT(t1.BorrowerName) AS 'Total Borrowed Books'
	FROM tbl_Borrower t1
		INNER JOIN tbl_BookLoans t2 ON t2.CardNumber = t1.CardNumber
	GROUP BY t1.BorrowerName, t1.BorrowerAddress
	;

	/*	Seventh, for each book authored or co-authored by Stephen King, 
		retrieve the title and number of copies owned by the library
		branch named Central. */
	SELECT
		t1.Title,
		t4.NumberOfCopies AS 'Number of Copies'
	FROM tbl_Book t1
		INNER JOIN tbl_BookAuthor t2 ON t2.BookID = t1.BookID
		INNER JOIN tbl_Author t3 ON t3.AuthorID = t2.AuthorID
		INNER JOIN tbl_BookCopies t4 ON t4.BookID = t1.BookID
		INNER JOin tbl_LibraryBranch t5 ON t5.BranchID = t4.BranchID
	WHERE T3.AuthorName = 'Stephen King' and t5.BranchName = 'Central'
	;

END

