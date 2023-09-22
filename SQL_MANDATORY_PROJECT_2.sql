-- ADVANCE SQL MANDATORY PROJECT ON IG_CLONE
-- SUBMITTED BY VIDHYADHAR MELAM  S4989 - DS30

-- 1 How many times does the average user post?

SELECT (SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users) AS average_user_post;

-- 2 Find the top 5 most used hashtags.

SELECT tag_name, COUNT(tag_id) AS total
FROM tags
INNER JOIN photo_tags ON tags.id = photo_tags.tag_id
GROUP BY tag_name
ORDER BY total DESC
lIMIT 5;

-- 3 Find users who have liked every single photo on the site

SELECT users.id,username, COUNT(users.id) AS total_likes_by_user
FROM users
JOIN likes ON users.id = likes.user_id
GROUP BY users.id
HAVING total_likes_by_user = (SELECT COUNT(*) FROM photos);

-- 4  Retrieve a list of users along with their usernames and the rank of their account creation, 
-- ordered by the creation date in ascending order.

SELECT username AS UserName, created_at AS AccountCreated, 
DENSE_RANK () OVER (ORDER BY created_at ASC) AS Rank_no 
FROM users
GROUP BY UserName
ORDER BY Rank_no ASC;

-- 5 List the comments made on photos with their comment texts, photo URLs, and usernames of users who posted
-- the comments. Include the comment count for each photo

SELECT comments.comment_text, photos.image_url, users.username, COUNT(comment_text) AS total_comments_count
FROM photos
JOIN comments ON photos.user_id = comments.user_id
JOIN users ON users.id = comments.user_id
GROUP BY photos.user_id
ORDER BY username;

-- 6 For each tag, show the tag name and the number of photos associated with that tag. 
-- Rank the tags by the number of photos in descending order.
    
SELECT tag_name, COUNT(image_url) AS Total_Pics_Associated_With_tags,
DENSE_RANK () OVER (ORDER BY COUNT(image_url) DESC) AS Rank_no 
FROM photo_tags
JOIN comments ON photo_tags.photo_id = comments.photo_id
JOIN photos ON comments.user_id = photos.user_id
JOIN tags ON photos.id = tags.id
GROUP BY photos.id
ORDER BY Rank_no ;

-- 7List the usernames of users who have posted photos along with the count of photos they have posted. 
-- Rank them by the number of photos in descending order.

SELECT users.username, COUNT(photos.image_url), 
DENSE_RANK () OVER (ORDER BY COUNT(photos.image_url) DESC) AS Rank_no 
FROM users
INNER JOIN photos ON users.id = photos.user_id
GROUP BY photos.user_id
ORDER BY Rank_no ;

-- 8 Display the username of each user along with the creation date of their first posted photo 
-- and the creation date of their next posted photo.

SELECT username, 
FIRST_VALUE(users.created_at) OVER (ORDER BY users.created_at) AS first_posted,
LEAD(users.created_at) OVER (ORDER BY users.created_at) AS next_posted
FROM photos
INNER JOIN comments ON photos.user_id = comments.user_id
INNER JOIN users ON users.id = comments.user_id
GROUP BY username
ORDER BY username ASC;

-- 9 For each comment, show the comment text, the username of the commenter, 
-- and the comment text of the previous comment made on the same photo.

SELECT users.username, photos.image_url, comments.comment_text,
LAG(comment_text) OVER (ORDER BY comments.photo_id) AS previous_comment
FROM comments
INNER JOIN photos ON comments.user_id = photos.user_id
INNER JOIN users ON comments.user_id = users.id
ORDER BY username;

-- 10 Show the username of each user along with the number of photos they have posted and the number of photos posted by 
-- the user before them and after them, based on the creation date.

SELECT users.username, COUNT(image_url) AS total_photos,
LAG(COUNT(photos.image_url)) OVER (ORDER BY photos.created_at) AS photos_posted_before_count,
LEAD(COUNT(photos.image_url)) OVER (ORDER BY photos.created_at) AS photos_posted_after_count
FROM comments
INNER JOIN photos ON comments.user_id = photos.user_id
INNER JOIN users ON photos.user_id = users.id
GROUP BY username
ORDER BY username;




