	#1. Найдите всех сотрудников, которые работали как минимум в 2 департаментах. Вывести их имя и фамилию. Показать записи в порядке возрастания.
SELECT first_name, last_name 
FROM employees e
WHERE 
	(
    SELECT COUNT(*)
    FROM dept_emp d
    WHERE d.emp_no = e.emp_no) >= 2
ORDER BY first_name ASC; 

	#2. Вывести имя, фамилию и зарплату самого высокооплачиваемого сотрудника.
SELECT first_name, last_name, 
	(
    SELECT salary 
	FROM salaries s
    WHERE s.emp_no = e.emp_no
    ORDER BY salary 
    DESC LIMIT 1) AS max_salary
FROM employees e
WHERE emp_no = 
	(
    SELECT emp_no 
	FROM salaries 
    ORDER BY salary 
    DESC LIMIT 1);

	#3. Создайте запрос, который выбирает названия всех отделов, в которых работает более 100 сотрудников.
SELECT dept_name
FROM departments d
WHERE 
	(
    SELECT COUNT(*)
    FROM dept_emp de
    WHERE de.dept_no = d.dept_no) > 100;

	#4. Напишите запрос, который находит имена и фамилии всех сотрудников, которые никогда не были менеджерами.
SELECT first_name, last_name 
FROM employees e
WHERE emp_no NOT IN
	(
    SELECT emp_no 
    FROM dept_manager d
    WHERE d.emp_no = e.emp_no);

	#5. Создайте запрос, который для каждого отдела выводит сотрудников, получающих наибольшую зарплату в этом отделе.
SELECT de.dept_no, e.first_name, e.last_name, s.salary AS max_salary
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN salaries s ON e.emp_no = s.emp_no 
JOIN (
    SELECT de2.dept_no, MAX(s2.salary) AS max_salary
    FROM salaries s2
    JOIN dept_emp de2 ON s2.emp_no = de2.emp_no
    GROUP BY de2.dept_no
) e2 ON de.dept_no = e2.dept_no AND s.salary = e2.max_salary
ORDER BY de.dept_no;

	#6. Напишите запрос, который выбирает названия отделов, где средняя зарплата выше общей средней зарплаты по компании.
SELECT dept_name 
FROM departments d
JOIN dept_emp de ON d.dept_no = de.dept_no
JOIN salaries s ON  de.emp_no = s.emp_no
GROUP BY dept_name
HAVING AVG(salary) > (SELECT AVG(salary) FROM salaries);




    
    
  
    
   

        
        