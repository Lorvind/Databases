-- Part 1: Basic SELECT Queries[cite: 2]

-- Task 1.1: Write a query to select all employees, displaying their full name (concatenated first and last name), department, and salary.[cite: 2]
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name, 
    department, 
    salary 
FROM employees;

-- Task 1.2: Use SELECT DISTINCT to find all unique departments in the company.[cite: 2]
SELECT DISTINCT department 
FROM employees;

-- Task 1.3: Select all projects with their names and budgets, and create a new column called budget_category using a CASE expression.[cite: 2, 3]
SELECT 
    project_name, 
    budget, 
    CASE 
        WHEN budget > 150000 THEN 'Large' 
        WHEN budget BETWEEN 100000 AND 150000 THEN 'Medium' 
        ELSE 'Small' 
    END AS budget_category 
FROM projects;

-- Task 1.4: Write a query using COALESCE to display employee names and their emails. If email is NULL, display 'No email provided'.[cite: 3]
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name, 
    COALESCE(email, 'No email provided') AS email 
FROM employees;


-- Part 2: WHERE Clause and Comparison Operators[cite: 3]

-- Task 2.1: Find all employees hired after January 1, 2020.[cite: 3]
SELECT * 
FROM employees 
WHERE hire_date > '2020-01-01';

-- Task 2.2: Find all employees whose salary is between 60000 and 70000 (use the BETWEEN operator).[cite: 3]
SELECT * 
FROM employees 
WHERE salary BETWEEN 60000 AND 70000;

-- Task 2.3: Find all employees whose last name starts with 'S' or 'J' (use the LIKE operator).[cite: 3]
SELECT * 
FROM employees 
WHERE last_name LIKE 'S%' OR last_name LIKE 'J%';

-- Task 2.4: Find all employees who have a manager (manager_id IS NOT NULL) and work in the IT department.[cite: 3]
SELECT * 
FROM employees 
WHERE manager_id IS NOT NULL 
  AND department = 'IT';


-- Part 3: String and Mathematical Functions[cite: 3]

-- Task 3.1: Create a query that displays Employee names in uppercase, Length of their last names, and First 3 characters of their email address.[cite: 3]
SELECT 
    UPPER(CONCAT(first_name, ' ', last_name)) AS employee_name, 
    LENGTH(last_name) AS last_name_length, 
    SUBSTRING(email FROM 1 FOR 3) AS email_prefix 
FROM employees;

-- Task 3.2: Calculate the following for each employee: Annual salary, Monthly salary (rounded to 2 decimal places), A 10% raise amount.[cite: 3]
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,
    salary AS annual_salary, 
    ROUND(salary / 12, 2) AS monthly_salary, 
    salary * 0.10 AS raise_amount 
FROM employees;

-- Task 3.3: Use the format() function to create a formatted string for each project: "Project: [name] - Budget: $[budget] - Status: [status]"[cite: 3]
SELECT 
    FORMAT('Project: %s - Budget: $%s - Status: %s', project_name, budget, status) AS project_info 
FROM projects;

-- Task 3.4: Calculate how many years each employee has been with the company (use date functions and the current date).[cite: 3]
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name, 
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date)) AS years_with_company 
FROM employees;


-- Part 4: Aggregate Functions and GROUP BY[cite: 3]

-- Task 4.1: Calculate the average salary for each department.[cite: 3]
SELECT 
    department, 
    ROUND(AVG(salary), 2) AS avg_salary 
FROM employees 
GROUP BY department;

-- Task 4.2: Find the total hours worked on each project, including the project name.[cite: 3]
SELECT 
    p.project_name, 
    SUM(a.hours_worked) AS total_hours 
FROM projects p 
JOIN assignments a ON p.project_id = a.project_id 
GROUP BY p.project_name;

-- Task 4.3: Count the number of employees in each department. Only show departments with more than 1 employee (use HAVING).[cite: 3]
SELECT 
    department, 
    COUNT(*) AS employee_count 
FROM employees 
GROUP BY department 
HAVING COUNT(*) > 1;

-- Task 4.4: Find the maximum and minimum salary in the company, along with the total payroll (sum of all salaries).[cite: 3]
SELECT 
    MAX(salary) AS max_salary, 
    MIN(salary) AS min_salary, 
    SUM(salary) AS total_payroll 
FROM employees;


-- Part 5: Set Operations[cite: 4]

-- Task 5.1: Combine queries using UNION: Employees with salary > 65000 and Employees hired after 2020-01-01.[cite: 4]
SELECT 
    employee_id, 
    CONCAT(first_name, ' ', last_name) AS full_name, 
    salary 
FROM employees 
WHERE salary > 65000 
UNION 
SELECT 
    employee_id, 
    CONCAT(first_name, ' ', last_name) AS full_name, 
    salary 
FROM employees 
WHERE hire_date > '2020-01-01';

-- Task 5.2: Use INTERSECT to find employees who work in IT AND have a salary greater than 65000.[cite: 4]
SELECT 
    employee_id, 
    CONCAT(first_name, ' ', last_name) AS full_name 
FROM employees 
WHERE department = 'IT' 
INTERSECT 
SELECT 
    employee_id, 
    CONCAT(first_name, ' ', last_name) AS full_name 
FROM employees 
WHERE salary > 65000;

-- Task 5.3: Use EXCEPT to find all employees who are NOT assigned to any projects.[cite: 4]
SELECT employee_id 
FROM employees 
EXCEPT 
SELECT employee_id 
FROM assignments;


-- Part 6: Subqueries[cite: 4]

-- Task 6.1: Use EXISTS to find all employees who have at least one project assignment.[cite: 4]
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name 
FROM employees e 
WHERE EXISTS (
    SELECT 1 
    FROM assignments a 
    WHERE a.employee_id = e.employee_id
);

-- Task 6.2: Use IN with a subquery to find all employees working on projects with status 'Active'.[cite: 4]
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name 
FROM employees 
WHERE employee_id IN (
    SELECT a.employee_id 
    FROM assignments a 
    JOIN projects p ON a.project_id = p.project_id 
    WHERE p.status = 'Active'
);

-- Task 6.3: Use ANY to find employees whose salary is greater than ANY employee in the Sales department.[cite: 4]
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name, 
    salary 
FROM employees 
WHERE salary > ANY (
    SELECT salary 
    FROM employees 
    WHERE department = 'Sales'
);


-- Part 7: Complex Queries[cite: 4]

-- Task 7.1: Employee name, department, average hours worked across all their assignments, and their rank within their department by salary.[cite: 4]
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS full_name, 
    e.department, 
    (SELECT ROUND(AVG(hours_worked), 2) FROM assignments a WHERE a.employee_id = e.employee_id) AS avg_hours, 
    RANK() OVER (PARTITION BY e.department ORDER BY e.salary DESC) AS dept_salary_rank 
FROM employees e;

-- Task 7.2: Find projects where the total hours worked exceeds 150 hours. Display project name, total hours, and number of employees assigned.[cite: 4]
SELECT 
    p.project_name, 
    SUM(a.hours_worked) AS total_hours, 
    COUNT(DISTINCT a.employee_id) AS num_employees_assigned 
FROM projects p 
JOIN assignments a ON p.project_id = a.project_id 
GROUP BY p.project_id, p.project_name 
HAVING SUM(a.hours_worked) > 150;

-- Task 7.3: Create a report showing departments with total number of employees, average salary, highest paid employee name, using GREATEST and LEAST.[cite: 4]
WITH DeptStats AS (
    SELECT 
        department, 
        COUNT(*) AS total_employees, 
        ROUND(AVG(salary), 2) AS avg_salary,
        MAX(salary) AS max_salary,
        MIN(salary) AS min_salary
    FROM employees 
    GROUP BY department
)
SELECT 
    ds.department, 
    ds.total_employees, 
    ds.avg_salary, 
    (SELECT CONCAT(first_name, ' ', last_name) 
     FROM employees e 
     WHERE e.department = ds.department 
     ORDER BY salary DESC LIMIT 1) AS highest_paid_employee,
    GREATEST(ds.max_salary, ds.min_salary) AS highest_salary_bound,
    LEAST(ds.max_salary, ds.min_salary) AS lowest_salary_bound
FROM DeptStats ds;
