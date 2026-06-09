-- =========================================================
-- AUTHOR: Gerlib Andrii
-- TASK 10.1: JOIN VIEW (з'єднання кількох таблиць)
-- VIEW: vw_books_with_genres
-- Бізнес-логіка:
-- View об'єднує books, books_genres та genres,
-- щоб читач міг бачити кожну книгу разом з її жанрами.
-- Одна книга може з'являтись кілька разів —
-- по одному рядку на кожен прив'язаний жанр.
--
-- Таблиці:
--   books        — основна інформація про книгу
--   books_genres — зв'язкова таблиця many-to-many
--   genres       — довідник жанрів
--
-- Колонки результату:
--   book_id          — унікальний ідентифікатор книги (books.id)
--   book_title       — назва книги (books.title)
--   isbn             — міжнародний стандартний номер книги (books.isbn)
--   publication_year — рік видання книги (books.publication_year)
--   genre_id         — унікальний ідентифікатор жанру (genres.id)
--   genre_name       — назва жанру (genres.name)
--
-- З'єднання:
--   books → books_genres : books.id = books_genres.book_id
--   books_genres → genres : books_genres.genre_id = genres.id
-- =========================================================

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

-- Отримати всі книги разом з їхніми жанрами
SELECT *
FROM "vw_books_with_genres"
ORDER BY book_title, genre_name;

-- Знайти всі книги певного жанру
SELECT
    book_id,
    book_title,
    isbn,
    publication_year
FROM "vw_books_with_genres"
WHERE genre_name = 'Fantasy';

-- =========================================================
-- AUTHOR: Gerlib Andrii
-- TASK 10.2: HORIZONTAL VIEW (вибірка конкретних колонок)
-- VIEW: vw_books_basic
-- Бізнес-логіка:
-- View показує лише публічні бібліографічні поля книги:
-- назву, ISBN та рік видання.
-- Технічне поле id приховується від кінцевого користувача.
--
-- Таблиці:
--   books — основна інформація про книгу як бібліографічну сутність
--
-- Колонки результату:
--   title            — назва книги (books.title)
--   isbn             — міжнародний стандартний номер книги (books.isbn)
--   publication_year — рік видання книги (books.publication_year)
--
-- Приховані колонки:
--   id — технічний первинний ключ, не потрібен кінцевому користувачу
-- =========================================================

CREATE OR REPLACE VIEW "vw_books_basic" AS
SELECT
    b.title,
    b.isbn,
    b.publication_year
FROM books AS b;

-- Отримати повний каталог книг
SELECT *
FROM "vw_books_basic";

-- Пошук книги за частиною назви
SELECT *
FROM "vw_books_basic"
WHERE title ILIKE '%гаррі%';
