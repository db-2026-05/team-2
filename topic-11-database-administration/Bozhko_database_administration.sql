-- =========================================================
-- AUTHOR: Viktor B.
-- TASK 11: ADMIN ROLE (роль адміністратора бібліотеки)
-- ROLE: library_admin
----------------------
-- Бізнес-логіка:
-- Роль для адміністратора бібліотеки, який відповідає
-- за керування всіма даними системи.
-------------------------------------
-- Об'єкти:
--   library_admin — групова роль без права логіну (NOLOGIN за замовчуванням)
--   admin_user    — реальний користувач з правом логіну (LOGIN),
--   якому призначається роль library_admin
-----------------------------------------------------------
-- Права ролі library_admin:
--   USAGE ON SCHEMA public
--   ALL PRIVILEGES ON ALL TABLES IN SCHEMA public
--------------------------------------------------
-- ALTER DEFAULT PRIVILEGES:
--   Гарантує що нові таблиці, створені в майбутньому,
--   автоматично отримають ті ж права для library_admin.
-- =========================================================

-- Створення групової ролі адміністратора
CREATE ROLE library_admin;

-- Надати доступ до схеми public
GRANT USAGE ON SCHEMA public TO library_admin;

-- Повний доступ до всіх існуючих таблиць
GRANT ALL PRIVILEGES
ON ALL TABLES IN SCHEMA public
TO library_admin;

-- Автоматичне надання прав на майбутні таблиці
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL ON TABLES TO library_admin;

-- Створення користувача з правом логіну
CREATE USER admin_user
WITH LOGIN
PASSWORD 'admin123';

-- Призначення ролі користувачу
GRANT library_admin TO admin_user;

-- =========================================================
-- ПЕРЕВІРКА ПРАВ
-- =========================================================

-- Перегляд виданих прав ролі
SELECT grantee,
table_name,
privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'library_admin'
ORDER BY table_name, privilege_type;

-- Перемикання на роль library_admin
SET ROLE library_admin;

-- Дозволено: перегляд даних
SELECT *
FROM books
LIMIT 5;

-- Перевірка запису та видалення даних
BEGIN;

INSERT INTO genres (name)
VALUES ('TEMP_TEST_ADMIN_ROLE_2026');

DELETE FROM genres
WHERE name = 'TEMP_TEST_ADMIN_ROLE_2026';

ROLLBACK;

RESET ROLE;

-- =========================================================
-- CLEANUP BLOCK
-- Використовувати лише за потреби.
-- Порядок:
-- 1. REVOKE
-- 2. DROP USER
-- 3. DROP ROLE
-- =========================================================

-- REVOKE library_admin FROM admin_user;

-- DROP USER IF EXISTS admin_user;

-- DROP ROLE IF EXISTS library_admin;
