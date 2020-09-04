--Nicholas DeChant
--Review Scores Statistics Feed
--May 9 2020


use [data]

--stored proc takes input date and returns # of review scores, 5th&95th  percentile and name, title, url for highest reviews
Create procedure Metrics @todaysDate datetime AS (
    SELECT DISTINCT CAST(date as datetime) AS Date --convert date input to correct format
		,PERCENTILE_DISC(0.05) WITHIN GROUP (ORDER BY adjusted_score ASC) --compute 5th & 95th percentile
				OVER(PARTITION BY date) Percentile_Number5
		,PERCENTILE_DISC(0.95) WITHIN GROUP (ORDER BY adjusted_score ASC) 
				OVER(PARTITION BY date) Percentile_Number95, 
				m.name EpisodeName,  --include more columns, episode name, title, etc.
				e.name EpisodeTitle,
				count(adjusted_score) NumOfReviews,
				max(adjusted_score) HighestScore,
				p.url URL
		FROM dbo.StandardizedReviews s
		JOIN [dbo].[Episodes] e ON s.episode_id = e.episode_id --link tables together by uniqueID
		JOIN  [dbo].[Publications] p ON s.publication_id = p.publication_id
		JOIN  [dbo].[media] m ON s.media_id = m.media_id
	WHERE CAST(date as DATE) = @todaysDate --make date the right format
	GROUP BY s.adjusted_score, s.date, e.name, p.url, m.name
)
GO 

--stored proc takes input date and returns the next days records for an episodes Name, Title, URL, and its average review score 
Create procedure NewsFeed @todaysDate datetime AS (
	SELECT m.name NameOfShow, e.name Episode, p.url Link, avg(s.adjusted_score) AverageScore, DATEADD(day,1, @todaysDate) EndDate --DATEADD(day,1, @todaysDate) increases input date by +1
			FROM dbo.StandardizedReviews s
			JOIN [dbo].[Episodes] e ON s.episode_id = e.episode_id --link by unique id
			JOIN  [dbo].[Publications] p ON s.publication_id = p.publication_id
			JOIN  [dbo].[media] m ON s.media_id = m.media_id
	WHERE CAST(date as DATE) = DATEADD(day,1, @todaysDate) --make date the right format and increase the input date by one day
	GROUP BY p.name, m.name, p.url, e.name
)
GO

--stored proc runs two SELECT queries, the first returns the lowest rated episodes and score, and second query returns the highest rated episodes and scores
create procedure BestandWorst AS 
	
	SELECT TOP 10 e.name EpisodeName, AVG(s.adjusted_score) Score
		 FROM dbo.StandardizedReviews s
		 JOIN  [dbo].[Episodes] e ON s.episode_id = e.episode_id
		 GROUP BY e.name
		 order by score ASC;
	

	SELECT TOP 10 e.name EpisodeName, AVG(s.adjusted_score) Score
		 FROM dbo.StandardizedReviews s
		 JOIN  [dbo].[Episodes] e ON s.episode_id = e.episode_id
		 GROUP BY e.name
		 order by score DESC;
GO		 
		 
exec NewsFeed '2020-2-01' 
exec Metrics '2020-1-05' 
exec BestandWorst


