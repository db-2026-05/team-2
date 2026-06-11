-- =========================================================
-- AUTHOR: Gerlib Andrii
-- TASK 11: READ-ONLY ROLE (роль лише на читання)
-- ROLE: library_analyst
-- Бізнес-логіка:
-- Роль для аналітиків бібліотеки, які будують звіти
-- про видачі та резервування.
-- Отримує лише SELECT на всі таблиці схеми public —
-- без жодних прав на зміну даних.
--
-- Об'єкти:
--   library_analyst — групова роль без права логіну (NOLOGIN)
--   analyst_user    — реальний користувач з правом логіну (LOGIN),
--                     якому призначається роль library_analyst
--
-- Права ролі library_analyst:
--   USAGE ON SCHEMA public              — доступ до схеми
--   SELECT ON ALL TABLES IN SCHEMA public — читання всіх таблиць
--   INSERT, UPDATE, DELETE — явно заборонені
--
-- ALTER DEFAULT PRIVILEGES:
--   Гарантує що нові таблиці, створені в майбутньому,
--   автоматично отримають SELECT для ролі library_analyst
--   без необхідності повторно видавати права вручну.
-- =========================================================

-- Створення групової ролі без права логіну
CREATE ROLE library_analyst NOLOGIN;

-- Надати доступ до схеми public
GRANT USAGE ON SCHEMA public TO library_analyst;

-- Надати SELECT на всі існуючі таблиці
GRANT SELECT ON ALL TABLES IN SCHEMA public TO library_analyst;

-- Явно заборонити права на зміну даних
REVOKE INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public FROM library_analyst;

-- Автоматичний SELECT для майбутніх таблиць
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT SELECT ON TABLES TO library_analyst;

-- Явна заборона DML для майбутніх таблиць
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    REVOKE INSERT, UPDATE, DELETE ON TABLES FROM library_analyst;

-- Створення користувача з правом логіну
CREATE USER analyst_user
    WITH LOGIN
    PASSWORD 'SecureAnalystPassword123!';

-- Призначення ролі користувачу
GRANT library_analyst TO analyst_user;


-- =========================================================
-- ПЕРЕВІРКА ПРАВ
-- Виконувати від імені analyst_user
-- =========================================================

-- SELECT — дозволено, повертає дані
SELECT id, title, isbn
FROM books
LIMIT 5;

-- INSERT — відхиляється базою
-- ПОМИЛКА: ERROR: permission denied for table genres
INSERT INTO genres (name)
VALUES ('Test Genre');

-- UPDATE — відхиляється базою
-- ПОМИЛКА: ERROR: permission denied for table books
UPDATE books
SET title = 'Hacked'
WHERE id = 1;

-- DELETE — відхиляється базою
-- ПОМИЛКА: ERROR: permission denied for table members
DELETE FROM members
WHERE id = 1;
