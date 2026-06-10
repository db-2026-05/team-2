# TEAMWORK - Topic 10 (SQL Views)

## Склад команди
- Команда: Team 2
- Варіант предметної області: Library Management System (система управління бібліотекою)

## Таблиця внесків
| Учасник | Роль у команді | Що зроблено | Артефакти / файли |
|---|---|---|---|
| Gerlib Andrii | Books / genres | Horizontal view `vw_books_basic`, join view `vw_books_with_genres`, demo-`SELECT` до них | views.sql |
| Shmyhol Evhenii | Copies / members | Vertical view `vw_active_members`, оновлюване view `vw_available_copies` з `WITH CHECK OPTION` | views.sql |
| Yevhenii Shvaidetskyi | Borrowings | Mixed view `vw_books_authors`, 5-табличний join view `vw_member_borrowed_books` | views.sql |
| Krysa Oleksandr | Categories / authors | Join view `vw_books_categories`, demo-`SELECT` до нього | views.sql |
| Viktor Bozhko | Reservations / reviews | Subquery view `vw_top_rated_books`, UNION view `vw_all_reservations`, view-on-view `vw_reservations_summary` | views.sql |

## Контекст теми
- **Horizontal view** — Gerlib Andrii (`vw_books_basic`).
- **Vertical view** — Shmyhol Evhenii (`vw_active_members`).
- **Mixed view** — Yevhenii Shvaidetskyi (`vw_books_authors`).
- **Join views** — Gerlib (`vw_books_with_genres`), Krysa (`vw_books_categories`), Shvaidetskyi (`vw_member_borrowed_books`, 5 таблиць).
- **Subquery view** — Viktor Bozhko (`vw_top_rated_books`).
- **UNION view** — Viktor Bozhko (`vw_all_reservations`).
- **View-from-view** — Viktor Bozhko (`vw_reservations_summary` на основі `vw_all_reservations`).
- **`WITH CHECK OPTION`** — Shmyhol Evhenii (`vw_available_copies`).
- **Demo-`SELECT` і структура `views.sql`** — кожен учасник додавав приклади запитів до своїх view; файл упорядковано від простих представлень до складних.

## Коротке обгрунтування командного підходу
1. **Як ви розподілили типи views між учасниками:** кожен працював із тими таблицями, які створював у DDL/DML, тому і views будував на «своїй» частині схеми. Прості типи (horizontal, vertical, mixed) узяли окремі учасники, а складніші (subquery, UNION, view-on-view) — один учасник, щоб логіка резервувань була послідовною.
2. **Чому ці views важливі для предметної області:** вони закривають типові задачі бібліотеки — публічний каталог книг, список активних читачів, історія видач, книги з високим рейтингом, доступні примірники. Це те, що реально потрібно бібліотекарю або читачу без доступу до сирих таблиць.
3. **Як перевіряли практичну цінність і коректність кожного view:** запускали скрипти в PostgreSQL у порядку DDL → DML → views; до кожного view написали demo-`SELECT` і перевірили, що результат відповідає очікуванням. Для `vw_available_copies` окремо перевірили `WITH CHECK OPTION`: дозволені операції проходять, а спроба перевести примірник у статус `borrowed` через view коректно відхиляється базою.