-- ================================================================
-- SQL VIEWS (TOPIC 10) - LIBRARY MANAGEMENT SYSTEM
-- ================================================================
-- Командний скрипт із представленнями (views), що демонструє
-- різні патерни VIEW для предметної області "Бібліотека".
--
-- Порядок (від простих до складних):
--   1) Прості представлення (horizontal / vertical / mixed)
--   2) Представлення зі з'єднанням таблиць (join)
--   3) Представлення з підзапитом (subquery)
--   4) UNION-представлення та багатошарові (view-on-view)
--   5) Оновлюване представлення з WITH CHECK OPTION
-- ================================================================


-- ################################################################
-- # 01. HORIZONTAL VIEW (вибірка конкретних колонок)
-- # AUTHOR: Gerlib Andrii
-- ################################################################
-- VIEW: vw_books_basic
-- Призначення:
--   Показує лише публічні бібліографічні поля книги:
--   назву, ISBN та рік видання. Технічне поле id приховане
--   від кінцевого користувача.
-- Зв'язок зі схемою:
--   Базується на таблиці books.
-- ################################################################

CREATE OR REPLACE VIEW "vw_books_basic" AS
SELECT
    b.title,                -- назва книги
    b.isbn,                 -- міжнародний стандартний номер книги
    b.publication_year      -- рік видання
FROM books AS b;

-- повний каталог книг
SELECT * FROM "vw_books_basic";

-- пошук книги за частиною назви
SELECT * FROM "vw_books_basic"
WHERE title ILIKE '%гаррі%';


-- ################################################################
-- # 02. VERTICAL VIEW (фільтрація рядків)
-- # AUTHOR: Shmyhol Evhenii
-- ################################################################
-- VIEW: vw_active_members
-- Призначення:
--   "Активний читач" — це читач, який має хоча б одну активну
--   видачу (borrowing_statuses.name = 'active').
-- Зв'язок зі схемою:
--   members -> borrowings -> borrowing_statuses.
--   Допомагає бібліотекарю швидко бачити коло активних читачів
--   та їх контактні дані.
-- ################################################################

CREATE OR REPLACE VIEW "vw_active_members" AS
SELECT DISTINCT
    m.id AS member_id,
    (m.first_name || ' ' || m.last_name) AS full_name,
    m.email,
    m.phone
FROM members AS m
JOIN borrowings AS b ON b.member_id = m.id
JOIN borrowing_statuses AS bs ON bs.id = b.status_id
WHERE bs.name = 'active';

-- усі активні читачі та їх контакти
SELECT * FROM "vw_active_members";

-- контакти конкретного активного читача за email
SELECT full_name, email, phone
FROM "vw_active_members"
WHERE email = 'andrii.bond@example.com';


-- ################################################################
-- # 03. MIXED VIEW (вибрані колонки + фільтрація рядків)
-- # AUTHOR: Yevhenii Shvaidetskyi
-- ################################################################
-- VIEW: vw_books_authors
-- Призначення:
--   Поєднує вибрані колонки книги та автора (mixed) і реалізує
--   приклад "book titles and authors".
-- Зв'язок зі схемою:
--   books - book_authors - authors (зв'язок many-to-many).
--   Підтримує співавторство: книга з кількома авторами
--   повертається кількома рядками.
-- ################################################################

CREATE OR REPLACE VIEW "vw_books_authors" AS
SELECT
    b.id AS book_id,        -- ідентифікатор книги
    b.title,                -- назва книги
    a.id AS author_id,      -- ідентифікатор автора
    a.first_name,           -- ім'я автора
    a.last_name             -- прізвище автора
FROM books b
JOIN book_authors ba ON b.id = ba.book_id
JOIN authors a ON ba.author_id = a.id;

-- усі книги з їх авторами
SELECT * FROM "vw_books_authors";

-- усі автори конкретної книги (демонструє співавторство)
SELECT title, first_name, last_name
FROM "vw_books_authors"
WHERE book_id = 5
ORDER BY last_name;


-- ################################################################
-- # 04a. JOIN VIEW (з'єднання кількох таблиць) - жанри
-- # AUTHOR: Gerlib Andrii
-- ################################################################
-- VIEW: vw_books_with_genres
-- Призначення:
--   Об'єднує books, books_genres та genres, щоб бачити кожну книгу
--   разом з її жанрами. Одна книга може з'являтись кілька разів —
--   по одному рядку на кожен прив'язаний жанр.
-- Зв'язок зі схемою:
--   books - books_genres - genres (many-to-many).
-- ################################################################

CREATE OR REPLACE VIEW "vw_books_with_genres" AS
SELECT
    b.id          AS book_id,
    b.title       AS book_title,
    b.isbn,
    b.publication_year,
    g.id          AS genre_id,
    g.name        AS genre_name
FROM books AS b
JOIN books_genres AS bg ON bg.book_id = b.id
JOIN genres       AS g  ON g.id = bg.genre_id;

-- усі книги разом з їхніми жанрами
SELECT * FROM "vw_books_with_genres"
ORDER BY book_title, genre_name;

-- усі книги певного жанру
SELECT book_id, book_title, isbn, publication_year
FROM "vw_books_with_genres"
WHERE genre_name = 'Fantasy';


-- ################################################################
-- # 04b. JOIN VIEW (з'єднання кількох таблиць) - категорії
-- # AUTHOR: Krysa Oleksandr
-- ################################################################
-- VIEW: vw_books_categories
-- Призначення:
--   З'єднує books + book_categories + categories. Category не
--   описує зміст книги, а визначає її роль у бібліотечному процесі
--   (children, educational, archive, rare books тощо).
-- Зв'язок зі схемою:
--   books - book_categories - categories (many-to-many) —
--   одна книга може належати до кількох категорій.
-- ################################################################

CREATE OR REPLACE VIEW "vw_books_categories" AS
SELECT
    b.id AS book_id,            -- ідентифікатор книги
    b.title,                    -- назва книги
    c.id AS category_id,        -- ідентифікатор категорії
    c.name AS category_name     -- назва категорії
FROM books b
JOIN book_categories bc ON b.id = bc.book_id
JOIN categories c ON bc.category_id = c.id;

--усі книги з їх категоріями
SELECT * FROM "vw_books_categories";

-- усі категорії конкретної книги (демонструє many-to-many)
SELECT title, category_name
FROM "vw_books_categories"
WHERE book_id = 1
ORDER BY category_name;


-- ################################################################
-- # 04c. JOIN VIEW (5 таблиць) - історія видач читача
-- # AUTHOR: Yevhenii Shvaidetskyi
-- ################################################################
-- VIEW: vw_member_borrowed_books
-- Призначення:
--   Реалізує "members and the books they have borrowed" —
--   формує історію читання користувача.
-- Зв'язок зі схемою (5 таблиць):
--   members - borrowings - borrowing_items - book_copies - books.
--   Показує читача, назви взятих книг та дати (видачі, кінцева
--   та фактична дата повернення).
-- ################################################################

CREATE OR REPLACE VIEW "vw_member_borrowed_books" AS
SELECT
    m."id"                AS member_id,         -- ідентифікатор читача
    m."first_name"        AS member_first_name, -- ім'я читача
    m."last_name"         AS member_last_name,  -- прізвище читача
    b."id"                AS book_id,           -- ідентифікатор книги
    b."title"             AS book_title,        -- назва взятої книги
    bc."barcode"          AS copy_barcode,      -- штрихкод примірника
    br."borrowing_date"   AS borrowing_date,    -- дата видачі
    bi."due_date"         AS due_date,          -- кінцева дата повернення
    bi."return_date"      AS return_date        -- фактична дата повернення
FROM "members" m
JOIN "borrowings" br      ON br."member_id" = m."id"
JOIN "borrowing_items" bi ON bi."borrowing_id" = br."id"
JOIN "book_copies" bc     ON bc."id" = bi."book_copy_id"
JOIN "books" b            ON b."id" = bc."book_id";

-- вся історія видач (за читачем та датою видачі)
SELECT * FROM "vw_member_borrowed_books"
ORDER BY member_id, borrowing_date DESC;

-- вся історія читання конкретного читача
SELECT member_first_name, member_last_name, book_title,
       borrowing_date, due_date, return_date
FROM "vw_member_borrowed_books"
WHERE member_id = 1
ORDER BY borrowing_date DESC;

-- книги, які читач ще не повернув (активні видачі)
SELECT member_first_name, member_last_name, book_title,
       borrowing_date, due_date
FROM "vw_member_borrowed_books"
WHERE return_date IS NULL
ORDER BY due_date;


-- ################################################################
-- # 05. SUBQUERY VIEW (представлення з підзапитом)
-- # AUTHOR: Viktor Bozhko
-- ################################################################
-- VIEW: vw_top_rated_books
-- Призначення:
--   Відобразити книги із середнім рейтингом вище 4.
-- Зв'язок зі схемою:
--   books + book_reviews. Підзапит обчислює середній рейтинг
--   (AVG(rate)) для кожної книги, а зовнішній запит залишає
--   лише книги з рейтингом > 4.
-- ################################################################

CREATE OR REPLACE VIEW "vw_top_rated_books" AS
SELECT b.id AS book_id, b.title, rated_books.average_rating
FROM books b
JOIN (
    SELECT book_id, AVG(rate) AS average_rating
    FROM book_reviews
    GROUP BY book_id
) AS rated_books ON b.id = rated_books.book_id
WHERE rated_books.average_rating > 4;

-- всі книги з високим середнім рейтингом
SELECT * FROM "vw_top_rated_books";


-- ################################################################
-- # 06. UNION VIEW (об'єднання сумісних наборів)
-- # AUTHOR: Viktor Bozhko
-- ################################################################
-- VIEW: vw_all_reservations
-- Призначення:
--   Об'єднати активні та завершені/скасовані резервування в єдине
--   представлення з міткою типу (Active / Completed).
-- Зв'язок зі схемою:
--   reservations + reservation_statuses. UNION поєднує дві сумісні
--   вибірки за різними наборами статусів.
-- ################################################################

CREATE OR REPLACE VIEW "vw_all_reservations" AS
-- Активні резервування (статус pending)
SELECT r.id AS reservation_id, r.member_id, r.reservation_date,
       rs.name AS status_name, 'Active' AS reservation_type
FROM reservations AS r
JOIN reservation_statuses AS rs ON r.status_id = rs.id
WHERE rs.name = 'pending'
UNION
-- Завершені або скасовані резервування
SELECT r.id AS reservation_id, r.member_id, r.reservation_date,
       rs.name AS status_name, 'Completed' AS reservation_type
FROM reservations AS r
JOIN reservation_statuses AS rs ON r.status_id = rs.id
WHERE rs.name IN ('fulfilled', 'cancelled');

-- Демо: усі резервування з типом
SELECT * FROM "vw_all_reservations";


-- ################################################################
-- # 07. LAYERED VIEW (представлення на основі іншого представлення)
-- # AUTHOR: Viktor Bozhko
-- ################################################################
-- VIEW: vw_reservations_summary
-- Призначення:
--   Зведена інформація на основі vw_all_reservations:
--   кількість резервувань за типом.
-- Зв'язок зі схемою:
--   Будується поверх vw_all_reservations (view-on-view),
--   демонструючи повторне використання логіки.
-- ################################################################

CREATE OR REPLACE VIEW "vw_reservations_summary" AS
SELECT reservation_type, COUNT(*) AS reservation_count
FROM "vw_all_reservations"
GROUP BY reservation_type;

-- підсумок резервувань за типом
SELECT * FROM "vw_reservations_summary";


-- ################################################################
-- # 08. UPDATABLE VIEW with WITH CHECK OPTION
-- # AUTHOR: Shmyhol Evhenii
-- ################################################################
-- VIEW: vw_available_copies
-- Призначення:
--   Показує лише фізичні примірники зі статусом 'available'.
--   WITH CHECK OPTION гарантує, що через представлення не можна
--   вставити чи оновити рядок так, щоб він не відповідав умові
-- Зв'язок зі схемою:
--   book_copies - copy_statuses. Оновлюване представлення для
--   безпечного керування доступними примірниками.
-- ################################################################

CREATE OR REPLACE VIEW "vw_available_copies" AS
SELECT
    bc.id,
    bc.book_id,
    bc.barcode,
    bc.copy_status_id
FROM book_copies AS bc
WHERE bc.copy_status_id = (
    SELECT id FROM copy_statuses WHERE name = 'available'
)
WITH CHECK OPTION;

-- переглянути всі доступні примірники
SELECT * FROM "vw_available_copies";

-- додати новий доступний примірник через view (проходить CHECK OPTION)
INSERT INTO "vw_available_copies" (book_id, barcode, copy_status_id)
VALUES (
    1,
    'BC-NEW-0001',
    (SELECT id FROM "copy_statuses" WHERE name = 'available')
);
 
--дозволене оновлення штрихкоду, статус лишається 'available'
UPDATE "vw_available_copies"
SET barcode = 'BC-UPD-0001'
WHERE id = 4;
 

-- перевірка на переведеня примірника у статус 'borrowed'
-- ВІДХИЛЯЄТЬСЯ базою тому що порушує WITH CHECK OPTION 
UPDATE "vw_available_copies"
SET copy_status_id = (SELECT id FROM "copy_statuses" WHERE name = 'borrowed')
WHERE id = 3;
