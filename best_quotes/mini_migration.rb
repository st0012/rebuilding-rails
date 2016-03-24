require "sqlite3"

connect = SQLite3::Database.new("test.db")
connect.execute <<SQL
create table quote (
  id INTEGER PRIMARY KEY,
  submitter VARCHAR(30),
  quote VARCHAR(100),
  attribution VARCHAR(30));
SQL

