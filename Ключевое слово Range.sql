	#1. Определение наивысшей текущей зарплаты в каждом отделе 
SELECT de.emp_no, s.salary, de.dept_no, 
	MAX(s.salary) OVER (PARTITION BY de.dept_no) AS max_salary_dept
FROM dept_emp de JOIN salaries s ON de.emp_no = s.emp_no
WHERE de.to_date = '9999-01-01'
ORDER BY de.dept_no, s.salary DESC;

	#2. Сравнение зарплаты каждого сотрудника с средней зарплатой в их отделе:
SELECT de.emp_no, s.salary, de.dept_no,
	AVG(s.salary) OVER (PARTITION BY de.dept_no) AS avg_salary_dept
FROM dept_emp de JOIN salaries s ON de.emp_no = s.emp_no
ORDER BY de.dept_no, de.emp_no;

	#3. Ранжирование сотрудников в отделе по стажу работы:
SELECT e.emp_no, de.dept_no, e.hire_date, 
	DENSE_RANK() OVER (PARTITION BY de.dept_no ORDER BY e.hire_date ASC) AS experience_rank
FROM employees e JOIN dept_emp de ON e.emp_no = de.emp_no
WHERE de.to_date = '9999-01-01' 
ORDER BY de.dept_no, experience_rank;

	#4.Нахождение следующей должности каждого сотрудника:
SELECT e.emp_no, t.title, 
	LEAD(title, 1, 'нынешняя должность') OVER (PARTITION BY emp_no ORDER BY e.emp_no) AS next_title
FROM employees e JOIN titles t ON e.emp_no = t.emp_no;

	#5. Определение начальной и последней зарплаты сотрудника:
SELECT e.emp_no, s.salary, 
	FIRST_VALUE(s.salary) OVER (PARTITION BY e.emp_no ORDER BY e.emp_no) AS first_salary,
	LAST_VALUE(s.salary) OVER (PARTITION BY e.emp_no ORDER BY e.emp_no) AS last_salary
FROM employees e JOIN salaries s ON e.emp_no = s.emp_no;

	#6. Цель: Вычислить скользящее среднее зарплаты для каждого сотрудника, основываясь на его последних трех зарплатах.
SELECT emp_no, from_date, salary, 
	AVG(salary) OVER (PARTITION BY emp_no ORDER BY emp_no ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_salary
FROM salaries;

