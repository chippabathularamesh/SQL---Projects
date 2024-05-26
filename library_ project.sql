create database library_managment;
drop database library_managment;
use library_managment;

create table tbl_publisher(publisher_PublisherName varchar(255) primary key,
						publisher_PublisherAddress varchar(255),
                        publisher_PublisherPhone varchar(255));
create table tbl_borrower(borrower_CardNo tinyint primary key auto_increment,
						borrower_BorrowerName varchar(255),
                        borrower_BorrowerAddress varchar(255),
                        borrower_BorrowerPhone varchar(255));
create table tbl_library_branch(library_branch_BranchID tinyint primary key auto_increment,
								library_branch_BranchName varchar(255),
                                library_branch_BranchAddress varchar(255));
create table tbl_book(book_BookID tinyint primary key auto_increment,
					book_title varchar(255),
                    book_publisher_name varchar(255),
                    foreign key(book_publisher_name) references tbl_publisher(publisher_PublisherName));
create table tbl_book_authors(book_authors_AuthorID tinyint primary key auto_increment,
							book_authors_BookID tinyint,
                            book_authors_AuthorName varchar(255),
                            foreign key (book_authors_BookID) references tbl_book(book_BookID));
                            
create table tbl_book_copies(book_copies_CopiesID tinyint primary key auto_increment,
							book_copies_BookID tinyint,
							foreign key(book_copies_BookID) references tbl_book(book_BookID),
							book_copies_BranchID tinyint,
							foreign key (book_copies_BranchID) references tbl_library_branch(library_branch_BranchID),
							book_copies_No_Of_copies tinyint);
create table tbl_book_loans(book_loans_loansID tinyint primary key auto_increment,
					book_loans_BookID tinyint,
                    foreign key (book_loans_BookID) references tbl_book(book_BookID),
                    book_loans_branchID tinyint,
                    foreign key (book_loans_branchID) references tbl_library_branch(library_branch_BranchID),
                    book_loans_cardNo tinyint,
                    foreign key (book_loans_cardNo) references tbl_borrower(borrower_CardNo),
                    booK_loans_dateOut date,
                    book_loans_DueDate date);
                    
                    
show databases;

select * from tbl_publisher;
select * from tbl_borrower;
select * from tbl_library_branch;
select * from tbl_book;
select * from tbl_book_authors;
select * from tbl_book_copies;
select * from tbl_book_loans;

-- 1) How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
	
select library_branch_BranchName,book_title,book_copies_No_Of_copies

 from tbl_book t
 
 join tbl_book_copies bc
 
 on bc.book_copies_BookID = t.book_BookID
 
 join tbl_library_branch lb
 
 on lb.library_branch_BranchID = bc.book_copies_BranchID
 
 where book_title = 'The Lost Tribe' and library_branch_BranchName = 'Sharpstown';
                  
                  
--  How many copies of the book titled "The Lost Tribe" are owned by each library branch?

select book_title,library_branch_branchname library,book_copies_no_of_copies

from tbl_book t

join tbl_book_copies bc

on bc.book_copies_bookid = t.book_bookid join tbl_library_branch lb

on lb.library_branch_branchid = bc.book_copies_branchid

where book_title = 'The Lost Tribe';


/* Retrieve the names of all borrowers who do not have any books checked out*/ 

 select * from tbl_borrower
 
 where borrower_cardno not in (select book_loans_cardno from tbl_book_loans);
 
 /* For each book that is loaned out from the "Sharpstown" branch 
and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address. */

select borrower_BorrowerName, borrower_BorrowerAddress,book_title,library_branch_BranchName from tbl_borrower t

 join tbl_book_loans tl
 
 on tl.book_loans_cardNo = t.borrower_CardNo
 
 join tbl_library_branch lb
 
 on lb.library_branch_BranchID = tl.book_loans_branchID
 
 join tbl_book tbt
 
 on tbt.book_BookID = tl.book_loans_BookID
 
 where library_branch_BranchName = 'Sharpstown' and tl.book_loans_DueDate = '2/3/18';
 
 
 /* For each library branch, retrieve the branch name and the total number of books loaned out from that branch.*/
 
 select library_branch_BranchName,count(booK_loans_dateOut) loan_count from tbl_borrower t
 
 join tbl_book_loans tl
 
 on tl.book_loans_cardNo = t.borrower_CardNo
 
 join tbl_library_branch lb
 
 on lb.library_branch_BranchID = tl.book_loans_branchID
 
 join tbl_book tbt
 
 on tbt.book_BookID = tl.book_loans_BookID
 
 group by library_branch_BranchName;
 
 
 /* Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.*/
 
 with cte_1 as (select * from tbl_borrower t
 
 join tbl_book_loans tl
 
 on tl.book_loans_cardNo = t.borrower_CardNo
 
 join tbl_library_branch lb
 
 on lb.library_branch_BranchID = tl.book_loans_branchID
 
 join tbl_book tbt
 
 on tbt.book_BookID = tl.book_loans_BookID),
 
cte_2 as(select *, count(book_loans_BookID) over(partition by borrower_BorrowerName)  as count_ from cte_1)

select borrower_BorrowerName, borrower_BorrowerAddress,count_ from cte_2 where count_>5;


/* For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".*/

select book_authors_AuthorName,library_branch_BranchName,library_branch_BranchName,book_copies_No_Of_copies from `tbl_book_authoes` ba

join tbl_book b

on ba.book_authors_BookID = b.book_BookID

join tbl_book_copies bc 

on bc.book_copies_BookID = b.book_BookID

join tbl_library_branch lb

on lb.library_branch_BranchID = bc.book_copies_BranchID

where book_authors_AuthorName = 'Stephen King' and library_branch_BranchName = 'Central';

select * from tbl_book;

select * from tbl_book_copies;

select * from tbl_library_branch;


 
 



                    