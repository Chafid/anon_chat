# 🐪 Anonymous WebSocket Chat with Mojolicious

This is a simple real-time anonymous chat server built using [Mojolicious](https://mojolicious.org/) in Perl. Users can join the chat via a web page, choose a nickname, and exchange messages with others. Messages are stored in a SQLite database.

---

## 🚀 Features

- WebSocket-based real-time chat
- Anonymous nickname support
- Persistent message history using SQLite
- Simple frontend interface
- Built with Mojolicious (Perl) and Mojo::SQLite

---

## 📦 Requirements

- Perl (5.10+ recommended)
- Mojolicious
- Mojo::SQLite

Install dependencies:

```bash
sudo apt update
sudo apt install cpanminus sqlite3
cpanm Mojolicious Mojo::SQLite
```

---

## 🛠️ Running the App

1. Clone the repository:

```bash
git clone https://github.com/chafid/anon_chat.git
cd anonchat-mojo
```

2. Start the server with `morbo`:

```bash
morbo script/anon_chat
```

3. Open your browser:

```
http://localhost:3000
```

---

## 🗃️ Database

The server uses `chat.db` (SQLite) to store messages. The table is automatically created at startup with this schema:

```sql
CREATE TABLE messages (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nickname TEXT,
  message TEXT,
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

---

## 📁 Project Structure

```
anonchat/
├── lib/
│   └── AnonChat.pm         # Main Mojolicious app
├── public/
│   └── chat.js             # WebSocket frontend script
├── templates/
│   └── index.html.ep       # Main chat page
└── script/
    └── anon_chat           # Launch script for Mojolicious
```

---

## 📄 License

MIT License — Free for personal and commercial use.
