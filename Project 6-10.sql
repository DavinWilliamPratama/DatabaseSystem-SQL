--6
SELECT m.MovieID, m.MovieTitle, pub.PublisherEmail
FROM Movie m,
	(SELECT COUNT(Movie.MovieID) AS 'jum', PublisherID
	  FROM DetailTransaction, SalesTransaction, Movie
	  WHERE DetailTransaction.TransactionID = SalesTransaction.TransactionID AND
			DAY(TransactionDate) = 22
	  GROUP BY TransactionDate, PublisherID							
	 ) AS mov,
	 (SELECT PublisherName, PublisherID, 
	  [PublisherEmail] = SUBSTRING(PublisherEmail, 1, CHARINDEX('@', PublisherEmail)-1) 
	  FROM Publisher
	 ) AS pub,
	 (SELECT TransactionDate, COUNT(MovieID) AS 'jum'
	  FROM DetailTransaction, SalesTransaction
	  WHERE DetailTransaction.TransactionID = SalesTransaction.TransactionID
	  GROUP BY TransactionDate							
	 ) AS [tran]
	  WHERE mov.PublisherID = pub.PublisherID AND
			


			
			
			
			
			