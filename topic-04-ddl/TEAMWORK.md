# TEAMWORK - Topic 04 (SQL DDL)

## Склад команди
- Команда: Library Management System
- Варіант предметної області: локальна бібліотека / Library Management System

## Таблиця внесків
| Учасник | Роль у команді | Що зроблено | Артефакти / файли |
|---|---|---|---|
| Gerlib Andrii | Розробник базових бібліографічних сутностей та жанрової класифікації | Створив таблиці `books`, `genre`, `book_genre`, `authors`; описав книгу як бібліографічну сутність, жанри як довідник та зв’язок many-to-many між книгами і жанрами; додав перевірку року публікації `chk_pub_year`; додав FK для `book_genre` та індекси `idx_book_genre_genre_id`, `idx_book_reviews_book_id`. | `ddl.sql`: секції `books`, `genre`, `book_genre`, `authors`; ALTER TABLE для `book_genre`; CREATE INDEX для пошуку за жанром і відгуками по книзі |
| Krysa Oleksandr | Розробник авторів, категорій та зв’язків класифікації | Створив таблиці `book_authors`, `categories`, `book_categories`; реалізував зв’язок many-to-many між книгами й авторами, а також між книгами й категоріями; додав FK з `ON DELETE CASCADE`; додав індекси `idx_book_authors_author_id`, `idx_book_categories_cat_id`. | `ddl.sql`: секції `book_authors`, `categories`, `book_categories`; ALTER TABLE для `book_authors` і `book_categories`; CREATE INDEX для пошуку книг автора та книг за категорією |
| Shmyhol Evhenii | Розробник читачів, фізичних примірників і статусів копій | Створив таблиці `members`, `copy_statuses`, `book_copies`; описав читачів бібліотеки, життєвий цикл фізичних примірників та зв’язок примірника з книгою; додав початкові статуси `available`, `borrowed`, `reserved`, `lost`; додав FK для `book_copies`; додав індекси `idx_book_copies_status_id`, `idx_book_copies_book_id`, `idx_reservation_items_book_id`. | `ddl.sql`: секції `members`, `copy_statuses`, `book_copies`; INSERT для `copy_statuses`; ALTER TABLE для `book_copies`; CREATE INDEX для примірників та резервувань книги |
| Yevhenii Shvaidetskyi | Розробник модуля видачі книг | Створив таблиці `borrowing_statuses`, `borrowings`, `borrowing_items`; описав операцію видачі та конкретні фізичні примірники у видачі; додав початкові статуси `active`, `returned`, `overdue`; додав FK для видач і позицій видачі; додав унікальні індекси `uq_borrowing_copy`, `uq_borrowing_copy_active`; додав індекси для пошуку історії видач, статусів та конкретних примірників. | `ddl.sql`: секції `borrowing_statuses`, `borrowings`, `borrowing_items`; INSERT для `borrowing_statuses`; ALTER TABLE для `borrowings` і `borrowing_items`; UNIQUE INDEX та CREATE INDEX для модуля видачі |
| Viktor Bozhko | Розробник модуля резервувань і відгуків | Створив таблиці `reservation_statuses`, `reservations`, `reservation_items`, `book_reviews`; описав життєвий цикл резервування та відгуки користувачів; додав початкові статуси `pending`, `fulfilled`, `cancelled`; додав FK для резервувань, позицій резервування та відгуків; реалізував `ON DELETE SET NULL` для необов’язкового фізичного примірника в резервуванні; додав `chk_rate`, `uq_one_review_per_book` та індекси для резервувань. | `ddl.sql`: секції `reservation_statuses`, `reservations`, `reservation_items`, `book_reviews`; INSERT для `reservation_statuses`; ALTER TABLE для `reservations`, `reservation_items`, `book_reviews`; UNIQUE INDEX та CREATE INDEX для резервувань і відгуків |

## Контекст теми
Команда розробляла SQL DDL для бази даних системи керування бібліотекою. У межах роботи було створено таблиці для книг, авторів, жанрів, категорій, читачів, фізичних примірників, видач, резервувань і відгуків.

Відповідальність за створення таблиць була розподілена за логічними доменами предметної області: бібліографічні сутності, класифікація, читачі та примірники, видачі, резервування та відгуки. Первинні ключі були додані безпосередньо в `CREATE TABLE`, а зовнішні ключі, додаткові constraints, INSERT-и та індекси були згруповані за авторами у відповідних секціях DDL.

PK/FK забезпечують референційну цілісність між таблицями. Constraints використовуються для перевірки бізнес-правил, наприклад коректного року видання книги та діапазону оцінки відгуку. Індекси додані для типових сценаріїв пошуку: пошук книг за жанром, автором або категорією, пошук примірників за статусом, перегляд історії видач і резервувань, а також контроль активної видачі фізичного примірника.

## Коротке обґрунтування командного підходу
1. DDL-об’єкти були розподілені між учасниками за функціональними зонами: книги й жанри, автори й категорії, читачі й фізичні примірники, видачі, резервування та відгуки.
2. Такий поділ обрано тому, що кожен учасник відповідав за окремий логічний модуль бази даних, який можна було розробляти та перевіряти незалежно, але потім об’єднати через FK-зв’язки.
3. Відповідність DDL ER-діаграмі перевірялась через зіставлення таблиць, первинних ключів, зв’язків many-to-many, зовнішніх ключів, правил `ON DELETE`, constraints та індексів із запланованою структурою предметної області.

## Розподіл DDL-об’єктів за авторами
| Автор | Таблиці | INSERT | FK / ALTER TABLE | Індекси |
|---|---|---|---|---|
| Gerlib Andrii | `books`, `genre`, `book_genre`, `authors` | — | FK для `book_genre.book_id`, `book_genre.genre_id` | `idx_book_genre_genre_id`, `idx_book_reviews_book_id` |
| Krysa Oleksandr | `book_authors`, `categories`, `book_categories` | — | FK для `book_authors`, `book_categories` | `idx_book_authors_author_id`, `idx_book_categories_cat_id` |
| Shmyhol Evhenii | `members`, `copy_statuses`, `book_copies` | `copy_statuses` | FK для `book_copies.book_id`, `book_copies.copy_status_id` | `idx_book_copies_status_id`, `idx_book_copies_book_id`, `idx_reservation_items_book_id` |
| Yevhenii Shvaidetskyi | `borrowing_statuses`, `borrowings`, `borrowing_items` | `borrowing_statuses` | FK для `borrowings`, `borrowing_items` | `uq_borrowing_copy`, `uq_borrowing_copy_active`, `idx_borrowings_member_id`, `idx_borrowings_status_id`, `idx_borrowing_items_copy_id` |
| Viktor Bozhko | `reservation_statuses`, `reservations`, `reservation_items`, `book_reviews` | `reservation_statuses` | FK для `reservations`, `reservation_items`, `book_reviews` | `uq_one_review_per_book`, `idx_reservations_member_id`, `idx_reservations_status_id`, `idx_res_items_res_book`, `idx_reservation_items_copy_id` |
