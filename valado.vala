// Compile: $ valac --pkg curses -X -lncurses --pkg sqlite3 valado.vala

using Curses;
using Sqlite;


public class Valado : GLib.Object {


    public static void main(string[] args) {
        int SHOW_RESOLVED_TASKS = 0;

        stdout.printf("Hello\n");
        Storage storage = new Storage("mydb.db");
        string[] tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);

        for (int i=0; i<tasks.length; i++) {
            stdout.printf("Task %s: %s\n", i.to_string(), tasks[i]);
        }

        storage.resolve_task(3);
    }
}

public class Storage : GLib.Object {
    private Database db;
    //private int ugly_mutex = 0;
    private List<string> tasks = new List<string>();

    public Storage(string dbfile) {
        int rc;

        if (!FileUtils.test(dbfile, FileTest.IS_REGULAR)) {
            // create new database
            stdout.printf("Storage: creating a new database `%s`...\n", dbfile);
            rc = Database.open(dbfile, out this.db);
            string sql_stmt = """
                CREATE TABLE `tasks` (
                    id        integer NOT NULL PRIMARY KEY AUTOINCREMENT,
                    task      text,
                    created   timestamp NOT NULL DEFAULT CURRENT_DATE,
                    resolved  timestamp NULL DEFAULT NULL
                )
            """;
            rc = this.db.exec(sql_stmt);
        }
        else {
            // use existed databse
            rc = Database.open(dbfile, out this.db);
            if (rc != Sqlite.OK) {
                stderr.printf("Can't open database `%s`", dbfile);
            }
        }
    }

    public string[] get_tasks_list(int show_resolved) {
        Statement stmt;
        string[] tasks = {};

        string sql = """
            SELECT task FROM `tasks`
            ORDER BY created
        """;
        int rc = this.db.prepare_v2(sql, sql.length, out stmt);
        if (rc != Sqlite.OK) {
            stderr.printf("Error while selecting data...");

        }
        int cols = stmt.column_count();
        while (stmt.step() == Sqlite.ROW) {
            tasks += stmt.column_text(0);
        }

        return tasks;
    }

    public void create_task(string task) {
        string errmsg;
        string sql = """
            INSERT INTO tasks (task)
            VALUES ("%s");
        """.printf(task);

        int rc = this.db.exec(sql, null, out errmsg);
        if (rc != Sqlite.OK) {
            stderr.printf("Database Error: %s\n", errmsg);
        }
    }

    public void delete_task(int id) {
        string errmsg;
        string sql = """
            DELETE FROM tasks
            WHERE
                id = %s
        """.printf(id.to_string());

        int rc = this.db.exec(sql, null, out errmsg);
        if (rc != Sqlite.OK) {
            stderr.printf("Database Error: %s\n", errmsg);
        }
    }

    public void resolve_task(int id) {
        string errmsg;
        string sql = """
            UPDATE tasks SET resolved = CURRENT_DATE
            WHERE
                id = %s
        """.printf(id.to_string());
        int rc = this.db.exec(sql, null, out errmsg);
        if (rc != Sqlite.OK) {
            stderr.printf("Database Error: %s\n", errmsg);
        }
    }
}
