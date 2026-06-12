-- =========================================================
-- AUTHOR: Shmyhol Evhenii
-- TASK 11: Administration
-- Роль catalog_manager з table-level правами на каталог.
-- =========================================================

-- Роль для контент-менеджера каталогу.
CREATE ROLE catalog_manager NOLOGIN;

-- Користувач, який працює під цією роллю.
CREATE ROLE catalog_user LOGIN PASSWORD 'CatalogPass123!' INHERIT;
GRANT catalog_manager TO catalog_user;

-- Доступ до схеми.
GRANT USAGE ON SCHEMA public TO catalog_manager;


-- CRUD по таблицях каталогу.
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE books            TO catalog_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE authors          TO catalog_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE genres           TO catalog_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE categories       TO catalog_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE books_genres     TO catalog_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE book_authors     TO catalog_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE book_categories  TO catalog_manager;


-- Приватні таблиці читачів і видач — закриваємо доступ повністю.
REVOKE ALL PRIVILEGES ON TABLE members      FROM catalog_manager;
REVOKE ALL PRIVILEGES ON TABLE borrowings   FROM catalog_manager;
REVOKE ALL PRIVILEGES ON TABLE reservations FROM catalog_manager;
REVOKE ALL PRIVILEGES ON TABLE book_reviews FROM catalog_manager;


COMMENT ON ROLE catalog_manager IS
  'Контент-менеджер: CRUD по каталогу (books, authors, genres, categories та зв''язки). Без доступу до members, borrowings, reservations, book_reviews.';


-- Перевірка прав під catalog_user.
SET ROLE catalog_user;

-- Дозволено: правка каталогу.
UPDATE books
SET publication_year = 2020
WHERE id = 1;

-- Заборонено: дані читачів (ERROR: permission denied for table members).
SELECT id, email, phone
FROM members;

RESET ROLE;
