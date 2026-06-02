-- ================================================================
-- SQL DML TEMPLATE (TOPIC 09)
-- ================================================================
-- WHAT SHOULD BE ADDED HERE:
-- 1) INSERT scripts for all required tables in your database.
-- 2) At least 10 records per table with meaningful, realistic values.
-- 3) UPDATE / DELETE scripts where they are relevant to business logic.
-- 4) If UPDATE / DELETE are not relevant for a table, add a short note
--    in documentation explaining why.
-- 5) Comments by section so the script is easy to read and run.
--
-- SCRIPT GOALS:
-- - Populate the database with usable test data.
-- - Validate constraints through realistic DML scenarios.
-- - Support the core functionality of your application.
--
-- RECOMMENDED ORDER:
-- 1) Reference data (lookups/dictionaries)
-- 2) Core entities
-- 3) Transactional data
-- 4) Optional UPDATE / DELETE checks
--
-- IMPORTANT:
-- - Use anonymized or privacy-safe sample data where possible.
-- - The script must execute in PostgreSQL.
-- - Submit this as one SQL file.
-- ================================================================


-- ================================================================
-- Автор: Gerlib Andrii
-- Таблиці: books, genres, books_genres, authors
-- ================================================================


-- ================================================================
-- 1) ДОВІДКОВІ ДАНІ
-- ================================================================

-- Жанри книг.
-- Genre описує літературну природу книги.
INSERT INTO "genres" ("name")
VALUES
  ('Fantasy'),
  ('Detective'),
  ('Science Fiction'),
  ('Romance'),
  ('Historical'),
  ('Thriller'),
  ('Horror'),
  ('Biography'),
  ('Poetry'),
  ('Adventure');


-- ================================================================
-- 2) ОСНОВНІ СУТНОСТІ
-- ================================================================

-- Книги бібліотеки.
-- isbn унікальний, publication_year у межах 1000..2100.
INSERT INTO "books" ("title", "isbn", "publication_year")
VALUES
  ('The Witcher: The Last Wish',   '978-0-575-08244-1', 1993),
  ('Murder on the Orient Express', '978-0-00-711931-8', 1934),
  ('Dune',                         '978-0-441-17271-9', 1965),
  ('Pride and Prejudice',          '978-1-85326-000-1', 1813),
  ('Sapiens: A Brief History',     '978-0-06-231609-7', 2011),
  ('The Shining',                  '978-0-385-12167-5', 1977),
  ('Neuromancer',                  '978-0-441-56956-9', 1984),
  ('The Hobbit',                   '978-0-261-10295-8', 1937),
  ('Gone Girl',                    '978-0-307-58836-4', 2012),
  ('Steve Jobs',                   '978-1-4516-4853-9', 2011);


-- Автори книг.
-- Один автор може написати багато книг.
INSERT INTO "authors" ("first_name", "last_name")
VALUES
  ('Andrzej',    'Sapkowski'),
  ('Agatha',     'Christie'),
  ('Frank',      'Herbert'),
  ('Jane',       'Austen'),
  ('Yuval Noah', 'Harari'),
  ('Stephen',    'King'),
  ('William',    'Gibson'),
  ('John',       'Tolkien'),
  ('Gillian',    'Flynn'),
  ('Walter',     'Isaacson');


-- ================================================================
-- 3) ТРАНЗАКЦІЙНІ / ЗАЛЕЖНІ ДАНІ
-- ================================================================

-- Зв'язок книг та жанрів (many-to-many).
-- Одна книга може належати до кількох жанрів.
INSERT INTO "books_genres" ("book_id", "genre_id")
VALUES
  (1, 1),    -- The Witcher        -> Fantasy
  (1, 10),   -- The Witcher        -> Adventure
  (2, 2),    -- Orient Express     -> Detective
  (2, 6),    -- Orient Express     -> Thriller
  (3, 3),    -- Dune               -> Science Fiction
  (3, 10),   -- Dune               -> Adventure
  (4, 4),    -- Pride and Prejudice-> Romance
  (4, 5),    -- Pride and Prejudice-> Historical
  (5, 8),    -- Sapiens            -> Biography
  (6, 7),    -- The Shining        -> Horror
  (6, 6),    -- The Shining        -> Thriller
  (7, 3),    -- Neuromancer        -> Science Fiction
  (8, 1),    -- The Hobbit         -> Fantasy
  (8, 10),   -- The Hobbit         -> Adventure
  (9, 2),    -- Gone Girl          -> Detective
  (9, 6),    -- Gone Girl          -> Thriller
  (10, 8);   -- Steve Jobs         -> Biography


-- ================================================================
-- 4) ПЕРЕВІРКИ UPDATE / DELETE
-- ================================================================

-- books: виправлення року видання книги.
UPDATE "books"
SET "publication_year" = 1994
WHERE "isbn" = '978-0-575-08244-1';

-- books: уточнення назви книги.
UPDATE "books"
SET "title" = 'Dune (Special Edition)'
WHERE "isbn" = '978-0-441-17271-9';

-- genres: перейменування жанру у довіднику.
UPDATE "genres"
SET "name" = 'Sci-Fi'
WHERE "name" = 'Science Fiction';

-- books_genres: зміна жанрового зв'язку.
-- Прибираємо помилковий жанр та додаємо коректний.
DELETE FROM "books_genres"
WHERE "book_id" = 5 AND "genre_id" = 8;

INSERT INTO "books_genres" ("book_id", "genre_id")
VALUES
  (5, 5);   -- Sapiens -> Historical

-- books_genres: видалення одного жанрового зв'язку книги.
DELETE FROM "books_genres"
WHERE "book_id" = 6 AND "genre_id" = 6;

-- books: видалення книги.
-- Завдяки ON DELETE CASCADE автоматично видаляються
-- відповідні рядки у books_genres.
DELETE FROM "books"
WHERE "isbn" = '978-1-4516-4853-9';

-- genres: видалення жанру, що не використовується жодною книгою.
-- Завдяки ON DELETE CASCADE безпечно видаляється з довідника.
DELETE FROM "genres"
WHERE "name" = 'Poetry';

-- authors: виправлення імені автора (повне ім'я замість скороченого).
UPDATE "authors"
SET "first_name" = 'J.R.R.'
WHERE "first_name" = 'John' AND "last_name" = 'Tolkien';

-- authors: виправлення прізвища (помилка введення).
UPDATE "authors"
SET "last_name" = 'Harari'
WHERE "first_name" = 'Yuval Noah';

-- authors: видалення автора.
-- У DDL book_authors.author_id має ON DELETE CASCADE,
-- тож зв'язки автора з книгами видаляються автоматично.
-- Оскільки book_authors заповнюється у частині Krysa Oleksandr,
-- тут видаляється автор без активних зв'язків.
DELETE FROM "authors"
WHERE "first_name" = 'Walter' AND "last_name" = 'Isaacson';
