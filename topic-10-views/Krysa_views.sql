-- =========================================================
-- TASK 10 - VIEW BOOKS AND AUTHORS
--
-- Призначення:
-- Відобразити назви книг та авторів через таблицю-зв'язку
-- book_authors. Підтримує співавторство.
-- =========================================================

CREATE OR REPLACE VIEW vw_books_authors AS
SELECT
    b.id AS book_id,
    b.title,
    a.id AS author_id,
    a.first_name,
    a.last_name
FROM books b
JOIN book_authors ba ON b.id = ba.book_id
JOIN authors a ON ba.author_id = a.id;

-- Приклад використання:
SELECT * FROM vw_books_authors;


-- =========================================================
-- TASK 10 - VIEW BOOKS AND CATEGORIES
--
-- Призначення:
-- Відобразити книги та категорії, до яких вони належать.
-- =========================================================

CREATE OR REPLACE VIEW vw_books_categories AS
SELECT
    b.id AS book_id,
    b.title,
    c.id AS category_id,
    c.name AS category_name
FROM books b
JOIN book_categories bc ON b.id = bc.book_id
JOIN categories c ON bc.category_id = c.id;

-- Приклад використання:
SELECT * FROM vw_books_categories;