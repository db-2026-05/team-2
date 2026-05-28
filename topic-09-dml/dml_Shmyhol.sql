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
--
-- Автор: Shmyhol Evhenii-- Таблиці: members, copy_statuses, book_copies
-- ================================================================


-- ================================================================
-- 1) ДОВІДКОВІ ДАНІ
-- ================================================================

-- Статуси примірників.
INSERT INTO "copy_statuses" ("name")
VALUES
  ('damaged'),
  ('in_repair'),
  ('archived'),
  ('on_order'),
  ('withdrawn'),
  ('processing');


-- ================================================================
-- 2) ОСНОВНІ СУТНОСТІ
-- ================================================================

-- Читачі бібліотеки.
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
  ('Petro',    'Savchenko',  'petro.sav@example.com',      'petros',    '19581e27de7ced00ff1ce50b2047e7a567c76b1cbaebabe5ef03f7c3017bb5b7', '+380501234576', 'vul. Yavornytskoho 33, Dnipro');


-- ================================================================
-- 3) ТРАНЗАКЦІЙНІ / ЗАЛЕЖНІ ДАНІ
-- ================================================================

-- Фізичні примірники книг (10 записів).
-- ПРИМІТКА: таблиця "books" — зона відповідальності іншого студента.
-- Тут припускаємо, що книги з id 1..5 уже існують у "books".
-- id статусів: 1=available, 2=borrowed, 3=reserved, 4=lost
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
  (5, 'BC-0010', 1);


-- ================================================================
-- 4) ПЕРЕВІРКИ UPDATE / DELETE
-- ================================================================

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
WHERE "barcode" = 'BC-0006';

-- members: видалення читача без активних видач.
DELETE FROM "members"
WHERE "login" = 'petros';
