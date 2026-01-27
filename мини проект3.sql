	#Выведите сколько пользователей добавили книгу 'Coraline', сколько пользователей прослушало больше 10%. 
SELECT COUNT(DISTINCT ac.user_id) AS count_user,
	(SELECT COUNT(DISTINCT ac1.user_id) AS count_user 
	FROM audiobooks a1 
	JOIN audio_cards ac1 ON ac1.audiobook_uuid = a1.uuid
	WHERE a1.title = 'Coraline'
	AND ac1.progress > 0.1 * a1.duration) AS listen_10
FROM audiobooks a 
JOIN audio_cards ac ON ac.audiobook_uuid = a.uuid
WHERE a.title = 'Coraline';

	#По каждой операционной системе и названию книги выведите количество пользователей, сумму прослушивания в часах, не учитывая тестовые прослушивания. 
SELECT l.os_name, a.title, 
	COUNT(DISTINCT l.user_id) AS count_user, 
    SUM(l.position_to - l.position_from)/3600 AS sum_listen
FROM audiobooks a 
JOIN listenings l ON l.audiobook_uuid = a.uuid
WHERE l.is_test = 0
GROUP BY l.os_name, a.title;

	#Найдите книгу, которую слушает больше всего людей. 
SELECT a.title, COUNT(*) AS listen
FROM audio_cards ac 
JOIN audiobooks a ON ac.audiobook_uuid = a.uuid
GROUP BY a.title
ORDER BY listen DESC
LIMIT 1;
    
	#Найдите книгу, которую чаще всего дослушивают до конца.
SELECT a.title, COUNT(*) AS count_finished
FROM audio_cards ac 
JOIN audiobooks a ON ac.audiobook_uuid = a.uuid
WHERE ac.state = 'finished'
GROUP BY a.title
ORDER BY count_finished DESC
LIMIT 1;






