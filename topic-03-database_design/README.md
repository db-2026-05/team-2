# Subtaks for topic 03
# 🗄️ Database Design

> **As a team**, choose one of the `3` variants you will implement throughout the project. This step defines the context for all subsequent tasks. Discuss and select the variant that best matches your interests and learning goals.
---

## 📌 Project Milestones

<table>
<tr>
<td width="50%" valign="top">

### 🟢 MVP — Minimum Viable Product

![MVP](https://img.shields.io/badge/Level-MVP-10b981?style=for-the-badge)

The essential baseline — sufficient to **pass the project** and proves core database understanding.

- ✅ Design basic tables and relationships
- ✅ Add, update, and retrieve essential records
- ✅ CRUD operations for each table
- ✅ Minimal but functional data model

</td>
<td width="50%" valign="top">

### 🟣 Final Version — Enhanced Learning

![Final](https://img.shields.io/badge/Level-Final%20Version-7c3aed?style=for-the-badge)

For teams wanting to **maximize learning** — advanced features and mastery of design concepts.

- 🚀 All advanced & optional features
- 🚀 Data validation & integrity checks
- 🚀 Comprehensive documentation
- 🚀 Design choices explained

</td>
</tr>
</table>
---

## 📐 Tasks
For your chosen variant, complete the following:

| # | Task | Details |
|---|------|---------|
| **01** | 📊 **Create an ER Diagram** | Visually represent the database structure — entities, relationships, key attributes |
| **02** | 🗂️ **Submit as PDF or Image** | Use [DB Designer](https://dbdiagram.io/home) or any tool of your choice |
| **03** | ✨ **Clarity & Organization** | Diagrams must be clear and easy to understand by others |

> [!TIP]
> Add a note on the ER diagram mentioning which **team members** were responsible for which parts. This helps clarify individual contributions.

> [!IMPORTANT]
> Clearly mark which parts belong to **MVP** and which are for the **Final Version**. Use color coding, labels, or other visual cues.

---

## 🎬 Additional Requirement — Video Recording

![Video](https://img.shields.io/badge/Required-~2%20min%20per%20person-f59e0b?style=for-the-badge&logo=zoom)

Each team member must record a **short video (~2 minutes)** describing:

- 🎯 The part of the solution you were responsible for
- 🧩 Challenges you faced
- 💡 How you addressed them

**Recording options:**

| Platform | How |
|----------|-----|
| 🟦 Zoom | Free version supports recording during a conference call |
| 📁 Google Drive | Upload and share the link |
| 🎞️ YouTube | Upload as **unlisted** video and share the link |

> [!WARNING]
> Video links **must be submitted** as part of the graded material alongside your code and documentation.

---

## Опис структури бази даних

### MVP таблиці

| Таблиця | Опис | Основні поля | PK | FK |
|---|---|---|---|---|
| `members` | Читачі бібліотеки та їх контактна інформація | `id`, `first_name`, `last_name`, `email`, `login`, `password_hash`, `phone`, `address` | `id` | — |
| `books` | Основна інформація про книги | `id`, `title`, `isbn`, `publication_year` | `id` | — |
| `borrowings` | Операції видачі та повернення книг | `id`, `member_id`, `borrowing_date`, `due_date`, `return_date`, `status_id` | `id` | `member_id → members.id`, `status_id → borrowing_statuses.id` |
| `authors` | Автори книг | `id`, `first_name`, `last_name` | `id` | — |
| `book_authors` | Зв’язок книг з авторами | `book_id`, `author_id` | `book_id + author_id` | `book_id → books.id`, `author_id → authors.id` |

### Final Version таблиці

| Таблиця | Опис | Основні поля | PK | FK |
|---|---|---|---|---|
| `genres` | Довідник жанрів | `id`, `name` | `id` | — |
| `book_genres` | Зв’язок книг з жанрами | `book_id`, `genre_id` | `book_id + genre_id` | `book_id → books.id`, `genre_id → genres.id` |
| `categories` | Довідник категорій | `id`, `name` | `id` | — |
| `book_categories` | Зв’язок книг з категоріями | `book_id`, `category_id` | `book_id + category_id` | `book_id → books.id`, `category_id → categories.id` |
| `copy_statuses` | Довідник статусів примірників | `id`, `name` | `id` | — |
| `book_copies` | Фізичні примірники книг | `id`, `book_id`, `barcode`, `copy_status_id` | `id` | `book_id → books.id`, `copy_status_id → copy_statuses.id` |
| `borrowing_statuses` | Довідник статусів видачі | `id`, `name` | `id` | — |
| `borrowing_items` | Конкретні примірники в межах видачі | `id`, `borrowing_id`, `book_copy_id` | `id` | `borrowing_id → borrowings.id`, `book_copy_id → book_copies.id` |
| `reservation_statuses` | Довідник статусів резервування | `id`, `name` | `id` | — |
| `reservations` | Резервування книг читачами | `id`, `member_id`, `reservation_date`, `status_id` | `id` | `member_id → members.id`, `status_id → reservation_statuses.id` |
| `reservation_items` | Книги або примірники в резервуванні | `id`, `reservation_id`, `book_id`, `book_copy_id`, `reservation_amount` | `id` | `reservation_id → reservations.id`, `book_id → books.id`, `book_copy_id → book_copies.id` |
| `book_reviews` | Відгуки та оцінки книг | `id`, `member_id`, `book_id`, `review_text`, `created_at`, `rate` | `id` | `member_id → members.id`, `book_id → books.id` |

---
