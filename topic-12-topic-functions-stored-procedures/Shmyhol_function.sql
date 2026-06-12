-- =========================================================
-- AUTHOR: Shmyhol Evhenii
-- TASK 12.4: FUNCTION fn_available_copies_count
-- =========================================================
-- Purpose:
--   Рахує кількість доступних примірників книги, щоб
--   бібліотекар одразу бачив, чи можна її видати.
-- Parameters:
--   p_book_id - id книги, для якої рахуємо примірники.
-- Behavior / Return value:
--   Повертає кількість примірників у book_copies, що
--   належать книзі та мають статус 'available'.
--   Якщо доступних примірників немає - повертає 0 (не NULL).
-- =========================================================
 
CREATE OR REPLACE FUNCTION fn_available_copies_count(p_book_id INT)
RETURNS INT
LANGUAGE sql
AS $$
  SELECT COUNT(*)::int
  FROM book_copies bc
  JOIN copy_statuses cs ON cs.id = bc.copy_status_id
  WHERE bc.book_id = p_book_id
    AND cs.name = 'available';
$$;
 
 
-- Тестові виклики.
SELECT fn_available_copies_count(1);
SELECT fn_available_copies_count(2);