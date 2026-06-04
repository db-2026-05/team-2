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

-- Add your DML below this line


-- ################################################################
-- ФАЗА 1. INSERT
-- ################################################################

-- ================================================================
-- 1.1 ДОВІДКОВІ ДАНІ
-- ================================================================
-- ПРИМІТКА: довідники copy_statuses, borrowing_statuses,
-- reservation_statuses частково наповнені у DDL
-- (available/borrowed/...; active/returned/overdue; pending/...).
-- Тут додаються лише відсутні значення.

-- Gerlib: жанри книг. Genre описує літературну природу книги.
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

-- Shmyhol: статуси примірників (решта довідника понад базові 5 з DDL).
INSERT INTO "copy_statuses" ("name")
VALUES
  ('in_repair'),
  ('archived'),
  ('on_order'),
  ('withdrawn'),
  ('processing');

-- Shvaidetskyi: статуси видач (решта довідника понад базові 3 з DDL).
INSERT INTO "borrowing_statuses" ("name")
VALUES
  ('lost'),
  ('reserved'),
  ('cancelled'),
  ('renewed'),
  ('pending'),
  ('damaged'),
  ('closed');

-- Bozhko: статуси резервування.
-- Базові pending/fulfilled/cancelled додані у DDL,
-- довідник є незмінним у межах DML, тому додаткових вставок немає.


-- ================================================================
-- 1.2 ОСНОВНІ СУТНОСТІ
-- ================================================================

-- Gerlib: книги бібліотеки. isbn унікальний, publication_year 1000..2100.
-- Книга id=11 ('To Be Removed') — службовий запис для демонстрації
-- DELETE у ФАЗІ 2 (на неї навмисно немає транзакційних посилань).
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
  ('Steve Jobs',                   '978-1-4516-4853-9', 2011),
  ('To Be Removed',                '978-0-00-000000-0', 2000);

-- Gerlib: автори книг. Один автор може написати багато книг.
-- Автор id=11 ('Removable Author') — службовий запис для DELETE у ФАЗІ 2.
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
  ('Walter',     'Isaacson'),
  ('Removable',  'Author');

-- Krysa Oleksandr: довідник категорій книг.
INSERT INTO "categories" ("name") VALUES
('Children''s Literature'),
('Educational & Textbooks'),
('Rare & Antique Books'),
('Local History & Lore'),
('Scientific & Research'),
('Art & Photo Albums'),
('Periodicals & Magazines'),
('Encyclopedias & Reference'),
('Banned & Restricted Books'),
('Donated & Gifted Collection'),
('Temporary Test Category');

-- Krysa Oleksandr: прив’язка книг з категоріями.
-- Для першої книги  дві категорії, щоб показати many-to-many.
INSERT INTO "book_categories" ("book_id", "category_id") VALUES
(1, 2),  
(1, 8),  
(2, 1),  
(3, 3),  
(4, 4),  
(5, 5),  
(6, 2),  
(7, 6),  
(8, 7),  
(9, 9),  
(10, 10);

-- Krysa Oleksandr: прив’язка книг до авторів. Для книги №5 два автори, 
-- щоб реалізувати вимогу щодо співавторства.
INSERT INTO "book_authors" ("book_id", "author_id") VALUES
(1, 1),  
(2, 2),  
(3, 3),  
(4, 4),  
(5, 5),  
(5, 6),  -- Оце якраз співавторство
(6, 7),  
(7, 8),  
(8, 9),  
(9, 10), 
(10, 1);

-- Shmyhol: читачі бібліотеки.
-- Читач id=11 (login 'removable') — службовий запис для DELETE у ФАЗІ 2.
INSERT INTO "members"
  ("first_name", "last_name", "email", "login", "password_hash", "phone", "address")
VALUES
  ('Olha',     'Kovalenko',  'olha.kovalenko@example.com', 'olhak',     '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', '+380501234567', 'vul. Shevchenka 12, Kyiv'),
  ('Andrii',   'Bondarenko', 'andrii.bond@example.com',    'andriib',   '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b', '+380671234568', 'vul. Lesi Ukrainky 5, Lviv'),
  ('Iryna',    'Tkachenko',  'iryna.tk@example.com',       'irynat',    'd4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35', '+380931234569', 'prosp. Svobody 88, Lviv'),
  ('Maksym',   'Shevchuk',   'maksym.sh@example.com',      'maksymsh',  '4e07408562bedb8b60ce05c1decfe3ad16b72230967de01f640b7e4729b49fce', '+380501234570', 'vul. Sahaidachnoho 3, Kyiv'),
  ('Nataliia', 'Melnyk',     'nataliia.m@example.com',     'nataliiam', '4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a', '+380671234571', 'vul. Soborna 21, Odesa'),
  ('Dmytro',   'Kravchenko', 'dmytro.kr@example.com',      'dmytrok',   'ef2d127de37b942baad06145e54b0c619a1f22327b2ebbcfbec78f5564afe39d', '+380931234572', 'vul. Hretska 14, Odesa'),
  ('Sofiia',   'Boiko',      'sofiia.boiko@example.com',   'sofiiab',   'e7f6c011776e8db7cd330b54174fd76f7d0216b612387a5ffcfb81e6f0919683', '+380501234573', 'vul. Pushkina 7, Kharkiv'),
  ('Volodymyr','Lysenko',    'volodymyr.l@example.com',    'volodyl',   '7902699be42c8a8e46fbbb4501726517e86b22c56a189f7625a6da49081b2451', '+380671234574', 'vul. Sumska 102, Kharkiv'),
  ('Kateryna', 'Marchenko',  'kateryna.m@example.com',     'katerynam', '2c624232cdd221771294dfbb310aca000a0df6ac8b66b696d90ef06fdefb64a3', '+380931234575', 'vul. Heroiv 9, Dnipro'),
  ('Petro',    'Savchenko',  'petro.sav@example.com',      'petros',    '19581e27de7ced00ff1ce50b2047e7a567c76b1cbaebabe5ef03f7c3017bb5b7', '+380501234576', 'vul. Yavornytskoho 33, Dnipro'),
  ('Removable','User',       'removable.user@example.com', 'removable', 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa1', '+380000000000', 'vul. Temp 1, Kyiv');


-- ================================================================
-- 1.3 ТРАНЗАКЦІЙНІ / ЗАЛЕЖНІ ДАНІ
-- ================================================================

-- Gerlib: зв'язок книг та жанрів (many-to-many).
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

-- Shmyhol: фізичні примірники книг.
-- Примірник BC-0011 (id=11) навмисно створено для DELETE у ФАЗІ 2
-- (списання загубленого примірника).
INSERT INTO "book_copies" ("book_id", "barcode", "copy_status_id")
VALUES
  (1, 'BC-0001', 1),
  (1, 'BC-0002', 2),
  (2, 'BC-0003', 1),
  (2, 'BC-0004', 3),
  (3, 'BC-0005', 1),
  (3, 'BC-0006', 4),
  (4, 'BC-0007', 2),
  (4, 'BC-0008', 1),
  (5, 'BC-0009', 3),
  (5, 'BC-0010', 1),
  (7, 'BC-0011', 1);

-- Shvaidetskyi: видачі книг (одна операція = один читач, можливо кілька книг).
INSERT INTO borrowings (member_id, borrowing_date, status_id) VALUES
  (1,  '2025-01-10 10:15:00', 2),
  (1,  '2025-01-10 10:15:00', 4),
  (2,  '2025-01-10 10:15:00', 2),
  (2,  '2025-01-15 14:20:00', 1),
  (3,  '2025-02-01 09:00:00', 3),
  (4,  '2025-02-10 16:45:00', 2),
  (5,  '2025-03-05 11:30:00', 1),
  (6,  '2025-03-12 13:15:00', 4),
  (7,  '2025-04-01 08:40:00', 2),
  (8,  '2025-04-18 17:00:00', 1),
  (9,  '2025-05-02 12:25:00', 3),
  (10, '2025-05-20 15:50:00', 1);

-- Shvaidetskyi: позиції видач (конкретні примірники у видачі).
-- ПРИМІТКА: book_copy_id посилається на book_copies.id (1..10).
INSERT INTO borrowing_items (borrowing_id, book_copy_id, return_date, due_date) VALUES
  (1,  1,  '2025-01-20 12:00:00', '2025-01-24 23:59:59'),
  (2,  2,  NULL,                  '2025-06-20 23:59:59'),
  (3,  3,  NULL,                  '2025-02-15 23:59:59'),
  (4,  4,  '2025-02-18 10:00:00', '2025-02-24 23:59:59'),
  (5,  5,  NULL,                  '2025-06-25 23:59:59'),
  (6,  6,  NULL,                  '2025-03-26 23:59:59'),
  (7,  7,  '2025-04-10 15:00:00', '2025-04-15 23:59:59'),
  (8,  8,  NULL,                  '2025-07-02 23:59:59'),
  (9,  9,  NULL,                  '2025-05-16 23:59:59'),
  (10, 10, NULL,                  '2025-07-15 23:59:59');

-- Bozhko: резервування. NULL у book_copy_id означає,
-- що конкретний примірник ще не призначений.
INSERT INTO reservations (member_id, reservation_date, status_id)
VALUES
  (1,  CURRENT_TIMESTAMP, 1),
  (2,  CURRENT_TIMESTAMP, 1),
  (3,  CURRENT_TIMESTAMP, 1),
  (4,  CURRENT_TIMESTAMP, 1),
  (5,  CURRENT_TIMESTAMP, 2),
  (6,  CURRENT_TIMESTAMP, 2),
  (7,  CURRENT_TIMESTAMP, 3),
  (8,  CURRENT_TIMESTAMP, 1),
  (9,  CURRENT_TIMESTAMP, 2),
  (10, CURRENT_TIMESTAMP, 1);

-- Bozhko: книги у резервуваннях.
INSERT INTO reservation_items (reservation_id, book_id, book_copy_id)
VALUES
  (1, 1,  NULL),
  (1, 2,  NULL),
  (2, 3,  NULL),
  (3, 4,  1),
  (4, 5,  2),
  (5, 6,  3),
  (6, 7,  NULL),
  (7, 8,  4),
  (8, 9,  NULL),
  (9, 10, 5);

-- Bozhko: відгуки користувачів.
INSERT INTO book_reviews (member_id, book_id, review_text, created_at, rate)
VALUES
  (1,  1,  'Interesting and engaging book.',        CURRENT_TIMESTAMP, 5),
  (2,  2,  'Very informative and useful.',          CURRENT_TIMESTAMP, 4),
  (3,  3,  'Good writing style.',                    CURRENT_TIMESTAMP, 5),
  (4,  4,  'The plot was a bit slow.',               CURRENT_TIMESTAMP, 3),
  (5,  5,  'Excellent characters and atmosphere.',   CURRENT_TIMESTAMP, 5),
  (6,  6,  'Nice book for beginners.',               CURRENT_TIMESTAMP, 4),
  (7,  7,  'Could be shorter.',                       CURRENT_TIMESTAMP, 3),
  (8,  8,  'One of the best books I have read.',     CURRENT_TIMESTAMP, 5),
  (9,  9,  'Average overall experience.',            CURRENT_TIMESTAMP, 3),
  (10, 10, 'Highly recommended.',                     CURRENT_TIMESTAMP, 5);



  -- ################################################################
-- ФАЗА 2. UPDATE / DELETE
-- ################################################################
-- ПРИМІТКА:
-- НЕМАЄ UPDATE ДЛЯ ТАБЛИЦЬ ЗВ'ЯЗКУ.
-- Робити UPDATE у таблицях багатьох до багатьох немає сенсу з боку бізнес-логіки програми. 

-- ----------------------------------------------------------------
-- Gerlib: books / genres / books_genres / authors
-- ----------------------------------------------------------------

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

-- books_genres: зміна жанрового зв'язку — прибрати помилковий, додати коректний.
DELETE FROM "books_genres"
WHERE "book_id" = 5 AND "genre_id" = 8;

INSERT INTO "books_genres" ("book_id", "genre_id")
VALUES
  (5, 5);   -- Sapiens -> Historical

-- books_genres: видалення одного жанрового зв'язку книги.
DELETE FROM "books_genres"
WHERE "book_id" = 6 AND "genre_id" = 6;

-- books: видалення книги.
DELETE FROM "books"
WHERE "isbn" = '978-0-00-000000-0';

-- genres: видалення жанру, що не використовується жодною книгою.
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
-- автора id=11 ('Removable Author').
DELETE FROM "authors"
WHERE "first_name" = 'Removable' AND "last_name" = 'Author';

-- ----------------------------------------------------------------
-- Krysa: categories / book_categories / book_authors
-- ----------------------------------------------------------------

-- categories: зміна назви категорії (наприклад, адмін вирішив уточнити назву)
UPDATE "categories"
SET "name" = 'Rare Books & Manuscripts'
WHERE "name" = 'Rare & Antique Books';

-- categories: видалення тестової категорії, яку ніхто не використовує (чисте видалення)
DELETE FROM "categories"
WHERE "name" = 'Temporary Test Category';

-- categories: прибрати книгу з категорії
DELETE FROM "book_categories"
WHERE "book_id" = 9 AND "category_id" = 9;

-- book_authors: видалення автора з книги
DELETE FROM "book_authors"
WHERE "book_id" = 10 AND "author_id" = 1;

-- ----------------------------------------------------------------
-- Shmyhol: members / book_copies
-- ----------------------------------------------------------------

-- members: читач змінив телефон та адресу.
UPDATE "members"
SET "phone" = '+380509998877',
    "address" = 'vul. Khreshchatyk 1, Kyiv'
WHERE "login" = 'olhak';

-- book_copies: примірник видали читачу (available -> borrowed).
UPDATE "book_copies"
SET "copy_status_id" = 2
WHERE "barcode" = 'BC-0001';

-- book_copies: примірник повернули (borrowed -> available).
UPDATE "book_copies"
SET "copy_status_id" = 1
WHERE "barcode" = 'BC-0007';

-- book_copies: загублений примірник списали з інвентарю.
DELETE FROM "book_copies"
WHERE "barcode" = 'BC-0011';

-- members: видалення читача без активних видач.
DELETE FROM "members"
WHERE "login" = 'removable';

-- ----------------------------------------------------------------
-- Bozhko: reservations / reservation_items / book_reviews
-- ----------------------------------------------------------------

-- reservations: оновлення статусу резервування.
UPDATE reservations
SET status_id = 2
WHERE id = 1;

-- reservation_items: призначення конкретного примірника книги.
UPDATE reservation_items
SET book_copy_id = 6
WHERE reservation_id = 1
  AND book_id = 1;

-- book_reviews: оновлення тексту відгуку та рейтингу.
UPDATE book_reviews
SET review_text = 'Excellent book with strong character development.',
    rate = 5
WHERE member_id = 4
  AND book_id = 4;

-- book_reviews: видалення відгуку користувача.
DELETE FROM book_reviews
WHERE member_id = 7
  AND book_id = 7;
