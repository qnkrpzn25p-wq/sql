-----------Количество пользователей добавивших книгу 'Coraline' и сколько пользователей прослушало больше 10%. 
SELECT COUNT(DISTINCT ac.user_id) AS count_user,
	(SELECT COUNT(DISTINCT ac1.user_id) AS count_user 
	FROM audiobooks a1 
	JOIN audio_cards ac1 ON ac1.audiobook_uuid = a1.uuid
	WHERE a1.title = 'Coraline'
	AND ac1.progress > 0.1 * a1.duration) AS listen_10
FROM audiobooks a 
JOIN audio_cards ac ON ac.audiobook_uuid = a.uuid
WHERE a.title = 'Coraline';


-----------Количество пользователей, сумма прослушивания в часах, не учитывая тестовые прослушивания по каждой книге. 
SELECT l.os_name, a.title, 
	COUNT(DISTINCT l.user_id) AS count_user, 
    SUM(l.position_to - l.position_from)/3600 AS sum_listen
FROM audiobooks a 
JOIN listenings l ON l.audiobook_uuid = a.uuid
WHERE l.is_test = 0
GROUP BY l.os_name, a.title;


-----------Книга, которую слушает больше всего людей. 
SELECT a.title, COUNT(*) AS listen
FROM audio_cards ac 
JOIN audiobooks a ON ac.audiobook_uuid = a.uuid
GROUP BY a.title
ORDER BY listen DESC
LIMIT 1;
    

------------Книга, которую чаще всего дослушивают до конца.
SELECT a.title, COUNT(*) AS count_finished
FROM audio_cards ac 
JOIN audiobooks a ON ac.audiobook_uuid = a.uuid
WHERE ac.state = 'finished'
GROUP BY a.title
ORDER BY count_finished DESC
LIMIT 1;

-----------Oтделы, где средняя зарплата выше общей средней зарплаты по компании.
SELECT dept_name 
FROM departments d
JOIN dept_emp de ON d.dept_no = de.dept_no
JOIN salaries s ON  de.emp_no = s.emp_no
GROUP BY dept_name
HAVING AVG(salary) > (SELECT AVG(salary) FROM salaries);


-----------Определение наивысшей текущей зарплаты в каждом отделе 
SELECT de.emp_no, s.salary, de.dept_no, 
	MAX(s.salary) OVER (PARTITION BY de.dept_no) AS max_salary_dept
FROM dept_emp de JOIN salaries s ON de.emp_no = s.emp_no
WHERE de.to_date = '9999-01-01'
ORDER BY de.dept_no, s.salary DESC;


-----------Ранжирование сотрудников в отделе по стажу работы:
SELECT e.emp_no, de.dept_no, e.hire_date, 
	DENSE_RANK() OVER (PARTITION BY de.dept_no ORDER BY e.hire_date ASC) AS experience_rank
FROM employees e JOIN dept_emp de ON e.emp_no = de.emp_no
WHERE de.to_date = '9999-01-01' 
ORDER BY de.dept_no, experience_rank;


-----------Определение начальной и последней зарплаты сотрудника:
SELECT e.emp_no, s.salary, 
	FIRST_VALUE(s.salary) OVER (PARTITION BY e.emp_no ORDER BY e.emp_no) AS first_salary,
	LAST_VALUE(s.salary) OVER (PARTITION BY e.emp_no ORDER BY e.emp_no) AS last_salary
FROM employees e JOIN salaries s ON e.emp_no = s.emp_no;









