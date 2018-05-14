


-- Ensure using the database
USE db_LibraryManagementSystem
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Populate_db_LibraryManagementSystem]
AS
BEGIN

	/******************************************************
	 * If our tables already exist, drop and recreate them
	 ******************************************************/
	IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tbl_Book)
		DROP TABLE tbl_BookAuthor, tbl_BookCopies, tbl_BookLoans, tbl_Book, tbl_Author, tbl_Publisher, tbl_LibraryBranch, tbl_Borrower;
		
		
	/******************************************************
	 * Build our database tables and define ther schema
	 ******************************************************/

	CREATE TABLE tbl_Book (
		BookID INT PRIMARY KEY NOT NULL IDENTITY (1,1),
		Title VARCHAR(50) NOT NULL,
		PublisherName VARCHAR(50) NOT NULL
	);

	CREATE TABLE tbl_Author (
		AuthorID INT PRIMARY KEY NOT NULL IDENTITY (1,1),
		AuthorName VARCHAR(50) NOT NULL,
	
	);

	CREATE TABLE tbl_Publisher (
		PublisherID INT PRIMARY KEY NOT NULL IDENTITY (1,1),
		PublisherName VARCHAR(50) NOT NULL,
		PublisherAddress VARCHAR(50) NOT NULL,
		PublisherPhone VARCHAR(50) NOT NULL
	);

	CREATE TABLE tbl_LibraryBranch (
		BranchID INT PRIMARY KEY NOT NULL IDENTITY (1,1),
		BranchName VARCHAR(50) NOT NULL,
		BranchAddress VARCHAR(50) NOT NULL,
	);

	CREATE TABLE tbl_BookLoans (
		BookLoanID INT PRIMARY KEY NOT NULL IDENTITY (1,1),
		BookID INT NOT NULL CONSTRAINT fk_BookID_3 FOREIGN KEY REFERENCES tbl_Book(BookID) ON UPDATE CASCADE ON DELETE CASCADE,
		BranchID INT NOT NULL CONSTRAINT fk_BranchID_3 FOREIGN KEY REFERENCES tbl_LibraryBranch(BranchID)  ON UPDATE CASCADE ON DELETE CASCADE,
		CardNumber INT NOT NULL,
		DateOut DATE NOT NULL,
		DateDue DATE NOT NULL,
	);

	CREATE TABLE tbl_Borrower (
		BorrowerID INT PRIMARY KEY NOT NULL IDENTITY (1,1),
		CardNumber INT NOT NULL,
		BorrowerName VARCHAR(50) NOT NULL,
		BorrowerAddress VARCHAR(50) NOT NULL,
		BorrowerPhone VARCHAR(50) NOT NULL
	);

	CREATE TABLE tbl_BookCopies (
		BookID INT NOT NULL CONSTRAINT fk_BookID_2 FOREIGN KEY REFERENCES tbl_Book(BookID) ON UPDATE CASCADE ON DELETE CASCADE, -- Could not have two fk with same name
		BranchID INT NOT NULL CONSTRAINT fk_BranchID_2 FOREIGN KEY REFERENCES tbl_LibraryBranch(BranchID)  ON UPDATE CASCADE ON DELETE CASCADE,
		PRIMARY KEY (BookID, BranchID),
		NumberOfCopies INT NOT NULL
	);

	CREATE TABLE tbl_BookAuthor (
		BookID INT NOT NULL CONSTRAINT fk_BookID FOREIGN KEY REFERENCES tbl_Book(BookID)  ON UPDATE CASCADE ON DELETE CASCADE,
		AuthorID INT NOT NULL CONSTRAINT fk_AuthorID FOREIGN KEY REFERENCES tbl_Author(AuthorID)  ON UPDATE CASCADE ON DELETE CASCADE,
		PRIMARY KEY (BookID, AuthorID)
	);

	/******************************************************
	* Now that the tables are built, we populate them
	******************************************************/
	INSERT INTO tbl_Book
		(Title, PublisherName)
		VALUES
		('The Lost Tribe', 'Picador USA'),
		('The Gunslinger', 'Simon and Schuster'),
		('The Dark Tower', 'Simon and Schuster'),
		('1984', 'Mass Market Paperback'),
		('A Brief History of Time', 'Bantam'),
		('All the President''s Men', 'Simon and Schuster'),
		('A Heartbreaking Work of Staggering Genius', 'Vintage'),
		('The Drawing of the Three', 'Simon and Schuster'),
		('The Wastelands', 'Simon and Schuster'),
		('Wizard and Glass', 'Simon and Schuster'), -- 10 books
		('Wolves of the Calla', 'Simon and Schuster'),
		('Angela''s Ashes', 'Scribner'),
		('Catch-22', 'Simon and Schuster'),
		('Dune', 'Ace'),
		('Fahrenheit 451', 'Simon and Schuster'), --15
		('Guns, Germs, and Steel', 'W. W. Norton and Company'),
		('Harry Potter and the Sorcerer''s Stone', 'Scholastic'),
		('Harry Potter and the Chamber of Secrets', 'Scholastic'),
		('Harry Potter and the Goblet of Fire', 'Scholastic'),
		('Harry Potter and the Order of the Phoenix', 'Scholastic') -- 20

	;
	SELECT * FROM tbl_Book

	INSERT INTO tbl_Author
		(AuthorName)
		VALUES
		('Mark Lee'),
		('Stephen King'),
		('George Orwell'),
		('Stephen Hawking'),
		('Bob Woodward'),
		('Carl Bernstein'),
		('Dave Eggers'),
		('Frank McCourt'),
		('Joseph Heller'),
		('Frank Herbert'), -- 10 authors
		('Ray Bradbury'),
		('Jared Diamond'),
		('J. K. Rowling')
	;
	SELECT * FROM tbl_Author

	INSERT INTO tbl_Publisher
		(PublisherName, PublisherAddress, PublisherPhone)
		VALUES
		('Picador USA', '324 W 9th St, Baltimore, MD 34343', '555-434-9843'),
		('Simon and Schuster', '2224 Airport Drive, Fort Worth, TX 67654', '555-783-9212'),
		('Mass Market Paperback', '123 Market Pl, Seattle, WA 98019', '555-943-1234'),
		('Bantam', '34 Ridge St, Citytown, ST 54123', '555-232-5643'),
		('Vintage', '9 w 2700 E, Utahtown, UT 43234', '555-567-4321'),
		('Scribner', '99 Main, Capital City, MA 34567', '555-239-3285'),
		('W. W. Norton and Company', '1981 W A St, Cliff, WV 56294', '555-823-2783'),
		('Scholastic', '345 6th Ct, Middletown, WA 98034', '555-432-4958')
	;
	SELECT * FROM tbl_Publisher

	INSERT INTO tbl_LibraryBranch
		(BranchName, BranchAddress)
		VALUES
		('Sharpstown', '54 W Main St, Sharpstown, MA 23234'),
		('Central', '1 Hermes Square, Suite 101, New York, NY 93434'),
		('Westside', '69 Shakur Shot, Los Angeles, CA 99435'),
		('Southside', '96 Usher Way, Los Angeles, CA 99456')

	;
	SELECT * FROM tbl_LibraryBranch

	INSERT INTO tbl_BookCopies
		(BookID, BranchID, NumberOfCopies)
		VALUES
		(1, 1, 10), -- Sharpstown has 10 copies of Lost Tribe
		(1, 2, 12),
		(1, 3, 14),
		(1, 4, 16),
		(2, 1, 3),
		(2, 2, 5),
		(2, 3, 7),
		(2, 4, 632),
		(3, 1, 2),
		(3, 2, 19),
		(3, 3, 40),
		(3, 4, 13),
		(4, 1, 7),
		(4, 2, 72),
		(4, 3, 27),
		(4, 4, 146),
		(5, 1, 12),
		(5, 2, 19),
		(5, 3, 34),
		(5, 4, 46),
		(6, 1, 50),
		(6, 2, 19),
		(6, 3, 54),
		(6, 4, 2),
		(7, 1, 2),
		(7, 2, 34),
		(7, 3, 23),
		(7, 4, 164),
		(8, 1, 100),
		(8, 2, 120),
		(8, 3, 17),
		(8, 4, 16),
		(9, 1, 9),
		(9, 2, 3),
		(9, 3, 16),
		(9, 4, 164),
		(10, 1, 10),
		(10, 2, 9),
		(10, 3, 14),
		(10, 4, 67),
		(11, 1, 45),
		(11, 2, 12),
		(11, 3, 141),
		(11, 4, 18),
		(12, 1, 15),
		(12, 2, 12),
		(12, 3, 14),
		(12, 4, 15),
		(13, 1, 10),
		(13, 2, 10),
		(13, 3, 10),
		(13, 4, 10),
		(14, 1, 10),
		(14, 2, 13),
		(14, 3, 14),
		(14, 4, 15),
		(15, 1, 10),
		(15, 2, 12),
		(15, 3, 14),
		(15, 4, 16),
		(16, 1, 19),
		(16, 2, 22),
		(16, 3, 34),
		(16, 4, 46),
		(17, 1, 105),
		(17, 2, 121),
		(17, 3, 181),
		(17, 4, 160),
		(18, 1, 2),
		(18, 2, 12),
		(18, 3, 16),
		(18, 4, 999),
		(19, 1, 13),
		(19, 2, 12),
		(19, 3, 14),
		(19, 4, 18),
		(20, 1, 26),
		(20, 2, 52),
		(20, 3, 84),
		(20, 4, 16)
;
	SELECT * FROM tbl_BookCopies

	INSERT INTO tbl_BookLoans
		(BookID, BranchID, CardNumber, DateOut, DateDue)
		VALUES
		(2, 3, 434567, '2018-03-15', '2018-04-15'),
		(1, 4, 434578, '2018-05-12', '2018-06-12'),
		(3, 2, 434237, '2018-01-01', '2018-05-14'),
		(4, 1, 434237, '2018-02-01', '2018-05-15'),
		(1, 1, 434235, '2018-03-01', '2018-05-16'),
		(5, 1, 434237, '2018-01-02', '2018-05-17'),
		(6, 2, 434237, '2018-02-02', '2018-05-18'),
		(7, 3, 434237, '2018-03-02', '2018-05-19'),
		(19, 1, 434981, '2018-03-04', '2018-05-14'),
		(18, 1, 434069, '2018-04-01', '2018-05-14'), --10
		(17, 2, 434069, '2018-04-02', '2018-05-14'),
		(16, 3, 434069, '2018-04-03', '2018-05-14'),
		(15, 4, 434069, '2018-04-03', '2018-05-14'),
		(19, 2, 434069, '2018-04-04', '2018-05-14'),
		(14, 1, 434823, '2018-05-01', '2018-06-01'),
		(13, 2, 434823, '2018-05-01', '2018-06-01'),
		(12, 3, 434823, '2018-05-02', '2018-06-02'),
		(11, 4, 434567, '2018-05-05', '2018-09-05'),
		(10, 3, 434567, '2018-01-01', '2018-03-15'),
		(9, 2, 434567, '2017-12-25', '2018-03-01'), --20
		(8, 1, 434567, '2018-05-05', '2018-05-14'),
		(1, 1, 434069, '2018-04-01', '2018-05-14'),
		(14, 2, 434069, '2018-04-02', '2018-05-14'),
		(12, 3, 434069, '2018-04-03', '2018-05-14'),
		(13, 4, 434069, '2018-04-03', '2018-05-14'),
		(11, 2, 434069, '2018-04-04', '2018-05-14'),
		(5, 3, 434567, '2018-03-15', '2018-04-15'),
		(6, 4, 434578, '2018-05-12', '2018-06-12'),
		(7, 2, 434237, '2018-01-01', '2018-05-14'),
		(8, 1, 434237, '2018-02-01', '2018-05-15'), --30
		(9, 1, 434235, '2018-03-01', '2018-05-16'),
		(20, 3, 434567, '2018-03-15', '2018-04-15'),
		(19, 4, 434578 ,'2018-05-12', '2018-06-12'),
		(17, 2, 434237, '2018-01-01', '2018-05-14'),
		(18, 1, 434237, '2018-02-01', '2018-05-15'),
		(17, 1, 434235, '2018-03-01', '2018-05-16'),
		(16, 1, 434237, '2018-01-02', '2018-05-17'),
		(5, 2, 434237, '2018-02-02', '2018-05-18'),
		(9, 3, 434237, '2018-03-02', '2018-05-19'),
		(15, 1, 434981, '2018-03-04', '2018-05-14'), --40
		(14, 1, 434069, '2018-04-01', '2018-05-14'), 
		(13, 2, 434069, '2018-04-02', '2018-05-14'),
		(12, 3, 434069, '2018-04-03', '2018-05-14'),
		(10, 4, 434069, '2018-04-03', '2018-05-14'),
		(9, 2, 434069, '2018-04-04', '2018-05-14'),
		(4, 1, 434823, '2018-05-01', '2018-06-01'),
		(3, 2, 434823, '2018-05-01', '2018-06-01'),
		(2, 3, 434823, '2018-05-02', '2018-06-02'),
		(1, 4, 434567, '2018-05-05', '2018-09-05'),
		(10, 3, 434567, '2018-01-01', '2018-03-15'), --50
		(9, 2, 434567, '2017-12-25', '2018-03-01')
	;
	SELECT * FROM tbl_BookLoans

	INSERT INTO tbl_Borrower
		(BorrowerName, CardNumber, BorrowerAddress, BorrowerPhone)
		VALUES
		('John Smith', 434567, '123 1 St', '555-324-5678'),
		('John Smith', 434578, '125 1 St', '555-678-3211'),
		('Mary Cradle', 434237, '56 West Ridge', '555-346-7865'),
		('Robert Gray', 434235, '9 Smith #401', '555-467-7543'),
		('Joseph Livid', 434981, '1010 Green Rd.', '555-432-1234'),
		('Josephine Livid', 434982, '1010 Green Rd.', '555-432-1234'),
		('Marcus Merry', 434823, '55 Studio', '555-346-8453'),
		('Anita Zayah', 434069, '99 Orchid', '555-234-8753')
	;
	SELECT * FROM tbl_Borrower

	INSERT INTO tbl_BookAuthor
		(BookID, AuthorID)
		VALUES
		(1, 1),
		(2, 2),
		(3, 2),
		(4, 3),
		(5, 4),
		(6, 5),
		(6, 6),
		(7, 7),
		(8, 2),
		(9, 2),
		(10, 2),
		(11, 2),
		(12, 8),
		(13, 9),
		(14, 10),
		(15, 11),
		(16, 12),
		(17, 13),
		(18, 13),
		(19, 13),
		(20, 13)
	;
	SELECT * FROM tbl_BookAuthor

END

GO