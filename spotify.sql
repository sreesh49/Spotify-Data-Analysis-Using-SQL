
---Advanced sql project --Spotify  Datasets

-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

--EDA

select count(*) from spotify
select * from spotify
select count(distinct artist) from spotify;
select count(distinct album) from spotify;

select distinct album_type from spotify;

select max(duration_min) from spotify;
select min(duration_min) from spotify;



delete  from spotify
where duration_min=0;
select * from spotify
where duration_min=0;

select distinct channel from spotify;

select distinct most_played_on from spotify;

/*
-- -------------------
-- Data Analysis -Easy Category
-- ---------------------
*/

--Q1-Retrieve the names of all tracks that have more than 1 billion streams.

select * from spotify;

select * from spotify
where stream>=10000,00000;

--Q2.List all albums with their respective artists.

select distinct album,artist from spotify
order by album;

--Q3.Get the total number of comments for tracks where licensed =True

--select distinct licensed from spotify.

select sum(comments) as sum_of_comments
from spotify
where licensed='true';

--Q4.Find all tracks that belong to the album type single.

select * from spotify
where album_type ilike 'single';

--Q5.Count the total number of tracks by each artist.

select * from spotify

select artist,count(*) as number_of_tracks
from spotify
group by artist
order by number_of_tracks desc

/*
-- ------------
Medium Level
-- -------------
*/

--Q6.Calculate the average dancibility of tracks in each album.

select * from spotify

select album ,avg(danceability) as average_dancibility
from spotify
group by album
order by average_dancibility desc
 
--Q7.Find the top 5 tracks with the highest energy values.


select track,max(energy) as highest_energy
from spotify 
group by track
order by highest_energy desc

--Q8.List all tracks along with views and likes where offical_video =TRUE

select track,sum(views) as total_views,sum(likes) as total_likes
from spotify
where official_video='true'
group by track
order by total_views desc

--Q9.For each album,calculate the total views of all associated tracks.

select * from spotify

select album,track,sum(views) as total_views
from spotify
group by album,track
order by total_views desc

--Q10.Retrieve the track names that have been streamed on spotify more than youtube.

select * from
(select track,
      coalesce(sum(case when most_played_on='Youtube' then stream end),0) as streamed_on_youtube,
	  coalesce(sum(case when most_played_on='Spotify' then stream end),0) as streamed_on_spotify
from spotify
group by track) as t1

where streamed_on_spotify>streamed_on_youtube
and
streamed_on_youtube<>0

--Q11.Find the top 3 most - viewed tracks for each artist using window function.

with ranking_artist
as
(select artist,track,sum(views) as total_view,
dense_rank() over(partition by artist order by sum(views) desc) as rank
from spotify
group by artist,track
order by artist,total_view desc) 
select * from ranking_artist
where rank<=3

--Q12.Write a query to find tracks where the liveness score is above the average.

select track,artist,liveness from spotify
where liveness>(select avg(liveness) from spotify)--0.19

--Q13.Use a with clause to calculate the difference between the highest and lowest energy values
---for tracks in each value.

with cte as
(
select album,
max(energy) as highest_energy,
min(energy) as lowest_energy
from spotify
group by album
)
select album,(highest_energy - lowest_energy) as energy_diff
from cte












