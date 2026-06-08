-- =========================================================
-- AUTHOR: Shmyhol Evhenii
-- TASK 10: MIXED VIEW (вибірка колонок + фільтрація рядків)
-- VIEW: vw_active_members

-- Бізнес-логіка:
-- "Активний читач" — це читач, який має хоча б одну
-- активну видачу (borrowings.status_id посилається на
-- borrowing_statuses.name = 'active').
-- =========================================================

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

-- Отримати всіх активних читачів та їх контактні дані
SELECT *
FROM vw_active_members;
 
-- Знайти контакти конкретного активного читача за email
SELECT 
    full_name,
    email,
    phone
FROM vw_active_members
WHERE email = 'andrii.bond@example.com';

henii
-- =========================================================
-- AUTHOR: Shmyhol Evhenii
-- TASK 10: UPDATABLE VIEW with WITH CHECK OPTION
-- VIEW: vw_available_copies

-- Бізнес-логіка:
-- View показує лише фізичні примірники зі статусом
-- 'available'.
-- =========================================================
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
 
 
-- Переглянути всі доступні примірники
SELECT *
FROM "vw_available_copies";
 
-- Додати новий доступний примірник через view (проходить CHECK OPTION)
INSERT INTO "vw_available_copies" (book_id, barcode, copy_status_id)
VALUES (
    1,
    'BC-NEW-0001',
    (SELECT id FROM "copy_statuses" WHERE name = 'available')
);
 
-- Дозволене оновлення штрихкоду, статус лишається 'available'
UPDATE "vw_available_copies"
SET barcode = 'BC-UPD-0001'
WHERE id = 4;
 

-- перевірка на переведеня примірника у статус 'borrowed'
-- ВІДХИЛЯЄТЬСЯ базою тому що порушує WITH CHECK OPTION 
UPDATE "vw_available_copies"
SET copy_status_id = (SELECT id FROM "copy_statuses" WHERE name = 'borrowed')
WHERE id = 3;
