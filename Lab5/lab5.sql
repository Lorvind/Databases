--------------------------------------------------------------------------------
-- PART 1: CHECK Constraints
--------------------------------------------------------------------------------

-- Task 1.1: Basic CHECK Constraint
CREATE TABLE employees (
    employee_id INTEGER,
    first_name TEXT,
    last_name TEXT,
    age INTEGER CHECK (age BETWEEN 18 AND 65),
    salary NUMERIC CHECK (salary > 0)
);

-- Task 1.2: Named CHECK Constraint
CREATE TABLE products_catalog (
    product_id INTEGER,
    product_name TEXT,
    regular_price NUMERIC,
    discount_price NUMERIC,
    CONSTRAINT valid_discount CHECK (
        regular_price > 0 AND 
        discount_price > 0 AND 
        discount_price < regular_price
    )
);

-- Task 1.3: Multiple Column CHECK
CREATE TABLE bookings (
    booking_id INTEGER,
    check_in_date DATE,
    check_out_date DATE,
    num_guests INTEGER CHECK (num_guests BETWEEN 1 AND 10),
    CONSTRAINT valid_dates CHECK (check_out_date > check_in_date)
);

-- Task 1.4: Testing CHECK Constraints
-- 1. Успешная вставка валидных данных:
INSERT INTO employees VALUES (1, 'Иван', 'Иванов', 30, 1500.00);
INSERT INTO employees VALUES (2, 'Анна', 'Петрова', 45, 2500.50);

INSERT INTO products_catalog VALUES (1, 'Laptop', 1200.00, 999.99);
INSERT INTO products_catalog VALUES (2, 'Phone', 800.00, 699.00);

INSERT INTO bookings VALUES (1, '2026-06-01', '2026-06-07', 2);
INSERT INTO bookings VALUES (2, '2026-07-10', '2026-07-15', 4);

/* 
   2 & 3. Неудачные попытки вставки (вызывают ошибки нарушения CHECK ограничений):
   
   -- Нарушение возраста (меньше 18):
   INSERT INTO employees VALUES (3, 'Петр', 'Сидоров', 16, 1000.00);
   -- Ошибка: new row for relation "employees" violates check constraint "employees_age_check"

   -- Нарушение зарплаты (меньше или равно 0):
   INSERT INTO employees VALUES (4, 'Ольга', 'Смирнова', 25, 0);
   -- Ошибка: new row for relation "employees" violates check constraint "employees_salary_check"

   -- Нарушение скидки (discount_price больше regular_price):
   INSERT INTO products_catalog VALUES (3, 'Tablet', 300.00, 350.00);
   -- Ошибка: new row for relation "products_catalog" violates check constraint "valid_discount"

   -- Нарушение дат (check_out_date раньше check_in_date):
   INSERT INTO bookings VALUES (3, '2026-08-10', '2026-08-05', 3);
   -- Ошибка: new row for relation "bookings" violates check constraint "valid_dates"
*/


--------------------------------------------------------------------------------
-- PART 2: NOT NULL Constraints
--------------------------------------------------------------------------------

-- Task 2.1: NOT NULL Implementation
CREATE TABLE customers (
    customer_id INTEGER NOT NULL,
    email TEXT NOT NULL,
    phone TEXT, -- Может быть NULL
    registration_date DATE NOT NULL
);

-- Task 2.2: Combining Constraints
CREATE TABLE inventory (
    item_id INTEGER NOT NULL,
    item_name TEXT NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 0),
    unit_price NUMERIC NOT NULL CHECK (unit_price > 0),
    last_updated TIMESTAMP NOT NULL
);

-- Task 2.3: Testing NOT NULL
-- 1. Успешная вставка полных записей (включая nullable колоноку phone):
INSERT INTO customers VALUES (1, 'ivan@mail.com', '+77011234567', '2026-01-10');
INSERT INTO inventory VALUES (1, 'Keyboard', 50, 45.99, NOW());

-- 2. Вставка с NULL в разрешенное поле (phone):
INSERT INTO customers VALUES (2, 'anna@mail.com', NULL, '2026-02-15');

/*
   3. Попытки вставки NULL в обязательные поля (NOT NULL):
   
   INSERT INTO customers VALUES (3, NULL, '+77029876543', '2026-03-01');
   -- Ошибка: null value in column "email" violates not-null constraint

   INSERT INTO inventory VALUES (2, 'Mouse', NULL, 15.00, NOW());
   -- Ошибка: null value in column "quantity" violates not-null constraint
*/


--------------------------------------------------------------------------------
-- PART 3: UNIQUE Constraints
--------------------------------------------------------------------------------

-- Task 3.1 & 3.3: Single Column UNIQUE with Named Constraints
CREATE TABLE users (
    user_id INTEGER,
    username TEXT,
    email TEXT,
    created_at TIMESTAMP,
    CONSTRAINT unique_username UNIQUE (username),
    CONSTRAINT unique_email UNIQUE (email)
);

-- Task 3.2: Multi-Column UNIQUE
CREATE TABLE course_enrollments (
    enrollment_id INTEGER,
    student_id INTEGER,
    course_code TEXT,
    semester TEXT,
    CONSTRAINT unique_enrollment UNIQUE (student_id, course_code, semester)
);

-- Тестирование UNIQUE ограничений:
INSERT INTO users VALUES (1, 'johndoe', 'john@example.com', NOW());
INSERT INTO course_enrollments VALUES (1, 101, 'CS101', 'Fall2026');

/*
   Попытка вставить дубликат по уникальному полю username:
   INSERT INTO users VALUES (2, 'johndoe', 'jane@example.com', NOW());
   -- Ошибка: duplicate key value violates unique constraint "unique_username"

   Попытка вставить дубликат комбинации для составного UNIQUE:
   INSERT INTO course_enrollments VALUES (2, 101, 'CS101', 'Fall2026');
   -- Ошибка: duplicate key value violates unique constraint "unique_enrollment"
*/


--------------------------------------------------------------------------------
-- PART 4: PRIMARY KEY Constraints
--------------------------------------------------------------------------------

-- Task 4.1: Single Column Primary Key
CREATE TABLE departments (
    dept_id INTEGER PRIMARY KEY,
    dept_name TEXT NOT NULL,
    location TEXT
);

-- Вставка данных и проверка ограничений первичного ключа:
INSERT INTO departments VALUES (1, 'HR', 'Building A');
INSERT INTO departments VALUES (2, 'IT', 'Building B');
INSERT INTO departments VALUES (3, 'Finance', 'Building C');

/*
   1. Попытка вставить дубликат dept_id (нарушение PRIMARY KEY / UNIQUE):
   INSERT INTO departments VALUES (1, 'Marketing', 'Building D');
   -- Ошибка: duplicate key value violates unique constraint "departments_pkey"

   2. Попытка вставить NULL в dept_id (нарушение PRIMARY KEY / NOT NULL):
   INSERT INTO departments VALUES (NULL, 'Marketing', 'Building D');
   -- Ошибка: null value in column "dept_id" violates not-null constraint
*/

-- Task 4.2: Composite Primary Key
CREATE TABLE student_courses (
    student_id INTEGER,
    course_id INTEGER,
    enrollment_date DATE,
    grade TEXT,
    PRIMARY KEY (student_id, course_id)
);


--------------------------------------------------------------------------------
-- Task 4.3: Comparison Exercise (Теоретический блок)
--------------------------------------------------------------------------------
/*
   1. Разница между UNIQUE и PRIMARY KEY:
      - PRIMARY KEY автоматически гарантирует уникальность и запрещает значения NULL. 
        В таблице может быть только один PRIMARY KEY.
      - UNIQUE также гарантирует уникальность данных, но разрешает одно значение NULL 
        (в зависимости от СУБД, в PostgreSQL — одно NULL-значение разрешено). В таблице 
        может быть сколько угодно UNIQUE ограничений.

   2. Когда использовать одиночный или составной PRIMARY KEY:
      - Одиночный PRIMARY KEY (Single-column): используется, когда у каждой записи есть 
        естественный или суррогатный уникальный идентификатор (например, id, isbn, employee_id).
      - Составной PRIMARY KEY (Composite): используется для таблиц связей (M:N), где уникальность 
        записи определяется комбинацией двух или более внешних ключей (например, student_id + course_id).

   3. Почему таблица может иметь только один PRIMARY KEY, но много UNIQUE:
      - Первичный ключ определяет каноническую, главную идентификацию строки в таблице 
        и используется по умолчанию для связывания с другими таблицами (Foreign Keys). 
        Ограничений UNIQUE может быть множество для разных бизнес-ключей (например, email, телефон, ИИН).
*/


--------------------------------------------------------------------------------
-- PART 5: FOREIGN KEY Constraints
--------------------------------------------------------------------------------

-- Task 5.1: Basic Foreign Key
CREATE TABLE employees_dept (
    emp_id INTEGER PRIMARY KEY,
    emp_name TEXT NOT NULL,
    dept_id INTEGER REFERENCES departments(dept_id),
    hire_date DATE
);

-- Успешная вставка (dept_id = 1 существует в таблице departments):
INSERT INTO employees_dept VALUES (1, 'Алексей Смирнов', 1, '2025-05-10');

/*
   Попытка вставить несуществующий dept_id:
   INSERT INTO employees_dept VALUES (2, 'Мария Ким', 99, '2025-06-01');
   -- Ошибка: insert or update on table "employees_dept" violates foreign key constraint
*/

-- Task 5.2: Multiple Foreign Keys (Library System)
CREATE TABLE authors (
    author_id INTEGER PRIMARY KEY,
    author_name TEXT NOT NULL,
    country TEXT
);

CREATE TABLE publishers (
    publisher_id INTEGER PRIMARY KEY,
    publisher_name TEXT NOT NULL,
    city TEXT
);

CREATE TABLE books (
    book_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author_id INTEGER REFERENCES authors(author_id),
    publisher_id INTEGER REFERENCES publishers(publisher_id),
    publication_year INTEGER,
    isbn TEXT UNIQUE
);

-- Образцы данных для लाइब्रेरी системы:
INSERT INTO authors VALUES (1, 'Лев Толстой', 'Россия');
INSERT INTO publishers VALUES (1, 'Эксмо', 'Москва');
INSERT INTO books VALUES (1, 'Война и мир', 1, 1, 1869, '978-5-699-12012-3');

-- Task 5.3: ON DELETE Options
CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL
);

CREATE TABLE products_fk (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category_id INTEGER REFERENCES categories(category_id) ON DELETE RESTRICT
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    order_date DATE NOT NULL
);

CREATE TABLE order_items (
    item_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products_fk(product_id),
    quantity INTEGER CHECK (quantity > 0)
);

-- Тестирование ON DELETE:
INSERT INTO categories VALUES (1, 'Электроника');
INSERT INTO products_fk VALUES (1, 'Смартфон', 1);

INSERT INTO orders VALUES (1, '2026-06-01');
INSERT INTO order_items VALUES (1, 1, 1, 2);

/*
   1. Попытка удалить категорию, у которой есть привязанные продукты (RESTRICT):
   DELETE FROM categories WHERE category_id = 1;
   -- Ошибка: update or delete on table "categories" violates foreign key constraint 
   -- "products_fk_category_id_fkey" on table "products_fk" (удаление заблокировано).

   2. Удаление заказа (CASCADE):
   DELETE FROM orders WHERE order_id = 1;
   -- Успешно удаляет заказ из таблицы orders и автоматически каскадно удаляет 
   -- связанные записи в таблице order_items.
*/


--------------------------------------------------------------------------------
-- PART 6: Practical Application (E-commerce Database Design)
--------------------------------------------------------------------------------

-- 1. Таблица клиентов
CREATE TABLE customers_ec (
    customer_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    registration_date DATE NOT NULL
);

-- 2. Таблица продуктов
CREATE TABLE products_ec (
    product_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC NOT NULL CHECK (price >= 0),
    stock_quantity INTEGER NOT NULL CHECK (stock_quantity >= 0)
);

-- 3. Таблица заказов
CREATE TABLE orders_ec (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers_ec(customer_id) ON DELETE RESTRICT,
    order_date DATE NOT NULL,
    total_amount NUMERIC NOT NULL CHECK (total_amount >= 0),
    status TEXT NOT NULL CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled'))
);

-- 4. Таблица деталей заказа
CREATE TABLE order_details_ec (
    order_detail_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders_ec(order_id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products_ec(product_id) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC NOT NULL CHECK (unit_price >= 0)
);

-- Вставка по 5+ записей в каждую таблицу системы E-commerce:

-- Customers (5 записей)
INSERT INTO customers_ec VALUES (1, 'Айбек Сатыбалдиев', 'aibek@mail.kz', '+77011112233', '2026-01-10');
INSERT INTO customers_ec VALUES (2, 'Динара Серикова', 'dinara@gmail.com', '+77022223344', '2026-02-14');
INSERT INTO customers_ec VALUES (3, 'Тимур Каримов', 'timur@mail.kz', NULL, '2026-03-05');
INSERT INTO customers_ec VALUES (4, 'Алия Омарова', 'aliya@yandex.kz', '+77054445566', '2026-04-20');
INSERT INTO customers_ec VALUES (5, 'Ержан Марат', 'erjan@mail.kz', '+77077778899', '2026-05-01');

-- Products (5 записей)
INSERT INTO products_ec VALUES (1, 'Беспроводные наушники', 'Bluetooth 5.3 с шумоподавлением', 25000.00, 15);
INSERT INTO products_ec VALUES (2, 'Смарт-часы', 'Фитнес-трекер, пульсометр', 45000.00, 10);
INSERT INTO products_ec VALUES (3, 'Механическая клавиатура', 'RGB подсветка, синие свитчи', 32000.00, 8);
INSERT INTO products_ec VALUES (4, 'Игровая мышь', '12000 DPI, эргономичная', 18000.00, 25);
INSERT INTO products_ec VALUES (5, 'Портативная колонка', 'Водонепроницаемая IPX7', 22000.00, 12);

-- Orders (5 записей)
INSERT INTO orders_ec VALUES (1, 1, '2026-06-01', 70000.00, 'delivered');
INSERT INTO orders_ec VALUES (2, 2, '2026-06-03', 32000.00, 'shipped');
INSERT INTO orders_ec VALUES (3, 3, '2026-06-05', 18000.00, 'processing');
INSERT INTO orders_ec VALUES (4, 1, '2026-06-06', 45000.00, 'pending');
INSERT INTO orders_ec VALUES (5, 5, '2026-06-07', 22000.00, 'cancelled');

-- Order Details (5 записей)
INSERT INTO order_details_ec VALUES (1, 1, 1, 2, 25000.00); -- 2 наушника по 25000
INSERT INTO order_details_ec VALUES (2, 1, 4, 1, 20000.00); -- 1 мышь (для примера суммы)
INSERT INTO order_details_ec VALUES (3, 2, 3, 1, 32000.00); -- 1 клавиатура
INSERT INTO order_details_ec VALUES (4, 3, 4, 1, 18000.00); -- 1 мышь
INSERT INTO order_details_ec VALUES (5, 4, 2, 1, 45000.00); -- 1 смарт-часы

-- Тестовые запросы на проверку ограничений E-commerce:
/*
   -- Проверка CHECK на недопустимый статус заказа:
   INSERT INTO orders_ec VALUES (6, 4, '2026-06-08', 10000.00, 'unknown_status');
   -- Ошибка: new row for relation "orders_ec" violates check constraint "orders_ec_status_check"

   -- Проверка UNIQUE на дублирование email клиента:
   INSERT INTO customers_ec VALUES (6, 'Новый Клиент', 'aibek@mail.kz', '+77000000000', '2026-06-08');
   -- Ошибка: duplicate key value violates unique constraint "customers_ec_email_key"

   -- Проверка CHECK на отрицательную цену продукта:
   INSERT INTO products_ec VALUES (6, 'Бракованный товар', 'Тест', -500.00, 5);
   -- Ошибка: new row for relation "products_ec" violates check constraint "products_ec_price_check"
*/
