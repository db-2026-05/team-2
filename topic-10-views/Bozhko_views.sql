-- =========================================================
-- ЗАВДАННЯ 9 - VIEW З ПІДЗАПИТОМ
--
-- Призначення:
-- Відобразити книги із середнім рейтингом вище 4.
--
-- Демонструє:
--   - підзапит (Subquery)
--   - GROUP BY
--   - AVG()
--   - JOIN
-- =========================================================

CREATE OR REPLACE VIEW view_top_rated_books AS
-- Підзапит обчислює середній рейтинг для кожної книги
SELECT b.id AS book_id,b.title,rated_books.average_rating
FROM books b JOIN (SELECT book_id, AVG(rate) AS average_rating 
                    FROM book_reviews 
                    GROUP BY book_id) AS rated_books 
              ON b.id = rated_books.book_id
-- Виводимо лише книги із середнім рейтингом вище 4
WHERE rated_books.average_rating > 4;

-- Приклад використання:
SELECT * FROM view_top_rated_books;

-- =========================================================
-- ЗАВДАННЯ 10 - VIEW З UNION
--
-- Призначення:
-- Об'єднати активні та завершені резервування
-- в єдине представлення.
--
-- Демонструє:
--   - UNION
--   - JOIN
--   - WHERE
-- =========================================================

CREATE OR REPLACE VIEW view_all_reservations AS
-- Активні резервування (статус pending)
SELECT r.id AS reservation_id,r.member_id,r.reservation_date,rs.name AS status_name,'Active' AS reservation_type
FROM reservations AS r
JOIN reservation_statuses AS rs ON r.status_id = rs.id
WHERE rs.name = 'pending'
UNION
-- Завершені або скасовані резервування
SELECT r.id AS reservation_id,r.member_id,r.reservation_date,rs.name AS status_name,'Completed' AS reservation_type
FROM reservations AS r
JOIN reservation_statuses AS rs ON r.status_id = rs.id
WHERE rs.name IN ('fulfilled', 'cancelled');

-- Приклад використання:
SELECT * FROM view_all_reservations;

-- =========================================================
-- ЗАВДАННЯ 11 - VIEW НА ОСНОВІ ІНШОГО VIEW
--
-- Призначення:
-- Побудувати зведену інформацію на основі
-- vw_all_reservations.
--
-- Демонструє:
--   - View on View
--   - GROUP BY
--   - COUNT()
-- =========================================================

CREATE OR REPLACE VIEW view_reservations_summary AS
-- Підрахунок кількості резервувань за типом
SELECT reservation_type, COUNT(*) AS reservation_count
FROM view_all_reservations
GROUP BY reservation_type;

-- Приклад використання:
SELECT * FROM view_reservations_summary;
