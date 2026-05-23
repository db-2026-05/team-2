# 🗄️ Database Design — Library Management System

## Опис структури бази даних

### MVP таблиці

| Таблиця | Опис | Основні поля | PK | FK |
|---|---|---|---|---|
| `members` | Читачі бібліотеки та їх контактна інформація | `id`, `first_name`, `last_name`, `email`, `login`, `password_hash`, `phone`, `address` | `id` | — |
| `books` | Основна інформація про книги | `id`, `title`, `isbn`, `publication_year` | `id` | — |
| `borrowings` | Операції видачі та повернення книг читачами | `id`, `member_id`, `borrowing_date`, `due_date`, `return_date`, `status_id`, `created_at`, `updated_at` | `id` | `member_id → members.id`, `status_id → borrowing_statuses.id` |
| `authors` | Автори книг | `id`, `first_name`, `last_name` | `id` | — |
| `books_authors` | Зв’язок багато-до-багатьох між книгами та авторами | `book_id`, `author_id` | `book_id + author_id` | `book_id → books.id`, `author_id → authors.id` |

---

### Final Version таблиці

| Таблиця | Опис | Основні поля | PK | FK |
|---|---|---|---|---|
| `genres` | Довідник жанрів книг | `id`, `name` | `id` | — |
| `book_genres` | Зв’язок книг з жанрами | `book_id`, `genre_id` | `book_id + genre_id` | `book_id → books.id`, `genre_id → genres.id` |
| `categories` | Довідник категорій книг | `id`, `name` | `id` | — |
| `book_categories` | Зв’язок книг з категоріями | `book_id`, `category_id` | `book_id + category_id` | `book_id → books.id`, `category_id → categories.id` |
| `copy_statuses` | Довідник статусів фізичних примірників книг | `id`, `name` | `id` | — |
| `book_copies` | Облік фізичних примірників книг | `id`, `book_id`, `barcode`, `copy_status_id` | `id` | `book_id → books.id`, `copy_status_id → copy_statuses.id` |
| `borrowing_statuses` | Довідник статусів видачі книг | `id`, `name` | `id` | — |
| `borrowing_items` | Конкретні примірники книг у межах однієї видачі | `id`, `borrowing_id`, `book_copy_id` | `id` | `borrowing_id → borrowings.id`, `book_copy_id → book_copies.id` |
| `reservation_statuses` | Довідник статусів резервування книг | `id`, `name` | `id` | — |
| `reservations` | Резервування книг читачами | `id`, `member_id`, `reservation_date`, `status_id`, `created_at`, `updated_at` | `id` | `member_id → members.id`, `status_id → reservation_statuses.id` |
| `reservation_items` | Книги або конкретні примірники, включені до резервування | `id`, `reservation_id`, `book_id`, `book_copy_id` | `id` | `reservation_id → reservations.id`, `book_id → books.id`, `book_copy_id → book_copies.id` |
| `book_reviews` | Відгуки та оцінки книг читачами | `id`, `member_id`, `book_id`, `review_text`, `created_at`, `rate` | `id` | `member_id → members.id`, `book_id → books.id` |

---

## Додаткові обмеження та перевірки

### Таблиця `members`
- `email` — унікальне значення
- `login` — унікальне значення, мінімум 3 символи
- `phone` — мінімум 10 символів
- `address` — мінімум 5 символів
- `password_hash` — мінімум 64 символи

### Таблиця `books`
- `isbn` — унікальне значення
- `publication_year` повинен бути між `1000` та `2100`

### Таблиця `borrowings`
- `due_date > borrowing_date`
- `return_date IS NULL OR return_date >= borrowing_date`

### Таблиця `book_reviews`
- `rate BETWEEN 1 AND 5`

---

## Індекси

### `borrowings`
- `idx_borrowings_member_status`
- `idx_borrowings_member`

### `borrowing_items`
- `idx_borrowing_items_copy`
- `uq_borrowing_copy`

### `reservations`
- `idx_reservations_member_status`
- `idx_reservations_member`

### `reservation_items`
- `idx_res_items_res_book`
- `idx_res_items_book`
- `idx_res_items_copy`

### `book_reviews`
- `uq_one_review_per_book`
