// Compile: $ valac --pkg curses -X -lncurses --pkg sqlite3 valado.vala

using Curses;
using Sqlite;


public class Valado : GLib.Object {


    public static void main(string[] args) {
        int SHOW_RESOLVED_TASKS = 0;

        stdout.printf("Hello\n");
        Storage storage = new Storage("mydb.db");
        storage.get_tasks_list(SHOW_RESOLVED_TASKS);

        //for (int i=0; i<tasks.length; i++) {
        //    stdout.printf("Task %s: %s\n", i.to_string(), tasks[i]);
        //}
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

    /*private int cb(int n_columns, string[] values, string[] column_names) {
        this.tasks.append(values[1]);
        for (int i=0; i<n_columns; i++) {
            stdout.printf("%s = %s\n", column_names[i], values[i]);
        }

        return 0;
    }*/

    public List<string> get_tasks_list(int show_resolved) {
        //string[] tasks = {"Task1", "Task2"};
        string sql_stmt = """
            SELECT * FROM tasks
        """;
        this.db.exec(sql_stmt, cb, null);

        return this.tasks;
    }
}
