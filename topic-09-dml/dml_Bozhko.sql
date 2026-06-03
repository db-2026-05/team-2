-- =========================================================
-- DML operations for reservation and review module
-- Author: Viktor Bozhko
-- =========================================================


-- =========================================================
-- reservation_statuses
-- =========================================================

-- Початкові статуси:
-- pending, fulfilled, cancelled
-- були додані на етапі DDL.
-- Видалення статусів не виконується,
-- оскільки вони використовуються у reservations
-- та можуть порушити цілісність даних.

-- Оновлення статусу fulfilled -> completed
UPDATE reservation_statuses
SET name = 'completed'
WHERE name = 'fulfilled';



-- =========================================================
-- reservations
-- =========================================================

-- Додавання резервувань
INSERT INTO reservations (member_id, reservation_date, status_id)
VALUES
(1, CURRENT_TIMESTAMP, 1),
(2, CURRENT_TIMESTAMP, 1),
(3, CURRENT_TIMESTAMP, 1),
(4, CURRENT_TIMESTAMP, 1),
(5, CURRENT_TIMESTAMP, 2),
(6, CURRENT_TIMESTAMP, 2),
(7, CURRENT_TIMESTAMP, 3),
(8, CURRENT_TIMESTAMP, 1),
(9, CURRENT_TIMESTAMP, 2),
(10, CURRENT_TIMESTAMP, 1);

-- Оновлення статусу резервування
UPDATE reservations
SET status_id = 2
WHERE id = 1;

-- Видалення статусу резервувань не рекомендується бізнес логікою
-- для повноти і цілісності інформації, щодо обігу книг.


-- =========================================================
-- reservation_items
-- =========================================================

-- Додавання книг до резервувань.
-- NULL у book_copy_id означає,
-- що конкретний примірник ще не призначений.

INSERT INTO reservation_items
(reservation_id, book_id, book_copy_id)
VALUES
(1, 1, NULL),
(1, 2, NULL),
(2, 3, NULL),
(3, 4, 1),
(4, 5, 2),
(5, 6, 3),
(6, 7, NULL),
(7, 8, 4),
(8, 9, NULL),
(9, 10, 5);

-- Призначення конкретного примірника книги
UPDATE reservation_items
SET book_copy_id = 6
WHERE reservation_id = 1
  AND book_id = 1;



-- =========================================================
-- book_reviews
-- =========================================================

-- Додавання відгуків користувачів
INSERT INTO book_reviews
(member_id, book_id, review_text, created_at, rate)
VALUES
(1, 1, 'Interesting and engaging book.', CURRENT_TIMESTAMP, 5),
(2, 2, 'Very informative and useful.', CURRENT_TIMESTAMP, 4),
(3, 3, 'Good writing style.', CURRENT_TIMESTAMP, 5),
(4, 4, 'The plot was a bit slow.', CURRENT_TIMESTAMP, 3),
(5, 5, 'Excellent characters and atmosphere.', CURRENT_TIMESTAMP, 5),
(6, 6, 'Nice book for beginners.', CURRENT_TIMESTAMP, 4),
(7, 7, 'Could be shorter.', CURRENT_TIMESTAMP, 3),
(8, 8, 'One of the best books I have read.', CURRENT_TIMESTAMP, 5),
(9, 9, 'Average overall experience.', CURRENT_TIMESTAMP, 3),
(10, 10, 'Highly recommended.', CURRENT_TIMESTAMP, 5);

-- Оновлення тексту відгуку та рейтингу
UPDATE book_reviews
SET
    review_text = 'Excellent book with strong character development.',
    rate = 5
WHERE member_id = 4
  AND book_id = 4;

-- Видалення відгуку користувача
DELETE FROM book_reviews
WHERE member_id = 7
  AND book_id = 7;
