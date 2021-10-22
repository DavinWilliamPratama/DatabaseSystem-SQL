USE Project
GO

-- 1
GO
SELECT m.MovieID,m.MovieTitle,m.MovieDescription,CONCAT(COUNT(DISTINCT u.UserID),' review(s)') [Reviews Movie]
FROM Movie m,SalesTransaction st, DetailTransaction dt, [User] u,Review r
WHERE st.TransactionID=dt.TransactionID AND u.UserID=st.UserID AND r.MovieID=dt.MovieID AND m.MovieID=dt.MovieID AND r.UserID=u.UserID
AND (u.UserCity='Bandung' OR r.Recommendationstatus='Not Recommended')
GROUP BY m.MovieID,m.MovieTitle,m.MovieDescription

-- 2
SELECT mg.GenreID,g.GenreName,COUNT(m.MovieID) [Total Movie]
FROM Movie_Genre mg,Genre g,Movie m
WHERE mg.GenreID=g.GenreID AND mg.MovieID=m.MovieID
AND m.DirectorID BETWEEN 'DIR004'AND'DIR008' AND DATEPART(mm,m.MovieReleaseDate)=2
GROUP BY mg.GenreID,g.GenreName

-- 3
SELECT d.DirectorID,d.DirectorName,CONCAT('+62',RIGHT(d.DirectorPhone,LEN(d.DirectorPhone)-1))[Local Phone],SUM(dt.Quantity)[Movie Sold],COUNT(dt.TransactionID)[Total Transaction]
FROM Director d,DetailTransaction dt,Movie m,(
SELECT d.DirectorID,d.DirectorName,d.DirectorPhone,SUM(dt.Quantity)[Movie Sold],COUNT(dt.TransactionID)[Total Transaction] --BIAR SUM BISA DIPAKAI DI WHERE CLAUSE
FROM Director d,DetailTransaction dt,Movie m
WHERE d.DirectorID=m.DirectorID AND dt.MovieID=m.MovieID AND d.DirectorID BETWEEN 'DIR003'AND'DIR009'
GROUP BY d.DirectorID,d.DirectorName,d.DirectorPhone
) as jz --EXTRACT SUM DOANG 
WHERE d.DirectorID=m.DirectorID AND dt.MovieID=m.MovieID AND jz.DirectorID=d.DirectorID
AND d.DirectorID BETWEEN 'DIR003'AND'DIR009' AND jz.[Movie Sold]>20
GROUP BY d.DirectorID,d.DirectorName,d.DirectorPhone

-- 4
SELECT u.UserNickname,UPPER(u.UserCity)[User City],SUM(dt.Quantity)[Total Movie Purchased],COUNT(DISTINCT dt.MovieID)[Movie Owned]
FROM [User] u,SalesTransaction st,DetailTransaction dt,Movie m 
WHERE u.UserID=st.UserID AND st.TransactionID=dt.TransactionID AND m.MovieID=dt.MovieID
AND u.UserID IN('USR002','USR003') AND DATEPART(mm,m.MovieReleaseDate)%2=1
GROUP BY u.UserNickname,u.UserCity

-- 5
SELECT RIGHT(u.UserID,3)[Numeric User Id],UPPER(u.UserNickname)[Nickname],u.UserCity
FROM [User] u, (
SELECT AVG(dt.Quantity) [average]
FROM DetailTransaction dt
)as averets,
(
SELECT u2.UserID,SUM(dt2.Quantity)[ktt]
FROM [User] u2, SalesTransaction st2,DetailTransaction dt2
WHERE u2.UserID=st2.UserID AND st2.TransactionID=dt2.TransactionID
GROUP BY u2.UserID
) as celaivyek
WHERE u.UserID=celaivyek.UserID AND celaivyek.ktt>averets.average AND u.UserNickname LIKE('%l%')

-- 6
SELECT DISTINCT m.MovieID,m.MovieTitle,p.PublisherName,p.PublisherEmail
FROM Movie m,Publisher p,DetailTransaction dt,(
SELECT MAX(dt.Quantity)[maximo]
FROM DetailTransaction dt,SalesTransaction st
WHERE st.TransactionID=dt.TransactionID
AND DATEPART(day,st.TransactionDate)=22
)as wadu
WHERE m.PublisherID=p.PublisherID AND dt.Quantity>wadu.maximo AND dt.MovieID=m.MovieID

-- 7 
SELECT D.DirectorID, D.DirectorName, Title.Title AS [MovieTitle], CONCAT(CAST(Genre.[Count] AS VARCHAR), ' genre(s)') AS [Total Genre]
FROM Director D,
(
    SELECT LOWER(M.MovieTitle) AS Title, M.DirectorID, M.MovieID
    FROM Movie M, Director D
    WHERE M.DirectorID = D.DirectorID
) Title,
(
    SELECT COUNT(G.GenreID) AS [Count], MG.MovieID
    FROM Movie M, Movie_Genre MG, Genre G
    WHERE M.MovieID = MG.MovieID AND MG.GenreID = G.GenreID
    GROUP BY MG.MovieID
) AS Genre
WHERE D.DirectorID = Title.DirectorID AND Genre.MovieID = Title.MovieID

-- 8
SELECT DISTINCT u.UserNickname,LEFT(u.UserFullName,CHARINDEX(' ',u.UserFullName+' '))[User First Name],q2.qty [Total Quantity]
FROM [User] u,SalesTransaction st, DetailTransaction dt,(
SELECT MAX(dt.Quantity) [maksimal]
FROM DetailTransaction dt,SalesTransaction st
WHERE DATEPART(day,st.TransactionDate)=20 AND dt.TransactionID=st.TransactionID
) AS q1,
(
SELECT u.UserID,SUM(dt.Quantity) [qty]
FROM [User] u,SalesTransaction st, DetailTransaction dt
WHERE u.UserID=st.UserID AND st.TransactionID=dt.TransactionID
GROUP BY u.UserID
)AS q2
WHERE u.UserID=st.UserID AND st.TransactionID=dt.TransactionID AND q2.qty>=q1.maksimal AND q2.UserID=u.UserID

-- 9
SELECT DISTINCT u.UserID, u.UserNickname, maxquan.maksimal, minquan.minimal
FROM SalesTransaction st
JOIN [User] u ON u.UserID=st.UserID
JOIN DetailTransaction dt ON dt.TransactionID=st.TransactionID,
    (
    SELECT MAX(dt.Quantity)[maksimal],u.UserID[uid]
    FROM [User] u,SalesTransaction st, DetailTransaction dt
    WHERE u.UserID=st.UserID AND st.TransactionID=dt.TransactionID AND
    DATEPART(DAY,st.TransactionDate)=19 
    GROUP BY u.UserID
    ) AS maxquan,
    (
    SELECT MIN(dt.Quantity)[minimal],u.UserID[uid]
    FROM [User] u,SalesTransaction st, DetailTransaction dt
    WHERE u.UserID=st.UserID AND st.TransactionID=dt.TransactionID AND
    DATEPART(DAY,st.TransactionDate)=19 
    GROUP BY u.UserID
    ) AS minquan
WHERE u.UserID=maxquan.uid AND u.UserID=minquan.uid AND u.UserNickname LIKE ('%h%')

-- 10
CREATE VIEW CustomPublisherViewer AS
SELECT publisher.PublisherName, movie.MovieTitle,  CONVERT(VARCHAR, movie.MovieReleaseDate, 106) AS [Release Date], SUM(qty.Quantity) AS [Total Pembelian]
        , MIN(qty.Quantity) AS [Pembelian Minimum]
FROM 
(
    SELECT MovieReleaseDate, MovieTitle, MovieID, PublisherID
    FROM Movie
    WHERE MONTH(MovieReleaseDate) = 7 
) AS movie,
(
    SELECT Quantity, MovieID
    FROM DetailTransaction
) AS qty,
(
    SELECT PublisherName, PublisherID
    FROM Publisher
    WHERE PublisherCity = 'Jakarta'
) AS publisher
WHERE movie.MovieID = qty.MovieID AND publisher.PublisherID = movie.PublisherID
GROUP BY publisher.PublisherName, movie.MovieTitle, movie.MovieReleaseDate
GO