CREATE DATABASE advanced_lab;

CREATE TABLE employees(
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(32),
    last_name VARCHAR(32),
    department VARCHAR(32),
    salary INT,
    hire_date DATE,
    status VARCHAR(32) DEFAULT 'Active'
);

CREATE TABLE departments(
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(32),
    budget INT,
    manager_id INT
);

CREATE TABLE projects(
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(32),
    dept_id INT,
    start_id DATE,
    end_date DATE,
    budget INT
);

