// Compile: $ valac --pkg sqlite3 valado.vala
using Sqlite;


public class Valado : GLib.Object {


    public static void main(string[] args) {
        Storage storage = new Storage("tasks.db");
        string command  = args[1];
        string argument = args[2];

        int SHOW_RESOLVED_TASKS = 0;

        switch(command) {
            case "-h":
                print_usage();
                break;

            case "-new":
                if (argument == null) {
                    stdout.printf("[error]: Need task value!\n");
                    print_usage();
                    break;
                }
                string task = argument;
                storage.create_task(task);
                string[] tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                print_tasks_list(tasks);
                break;

            case "-up":
                if (argument == null) {
                    stdout.printf("[error]: Need task number!\n");
                    print_usage();
                    break;
                }
                int task_num = int.parse(argument);
                string[] tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                if (tasks.length == 0) {
                    stdout.printf("The List is empty\n");
                    break;
                }

                storage.task_priority_up(tasks[task_num]);
                tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                print_tasks_list(tasks);
                break;

            case "-down":
                if (argument == null) {
                    stdout.printf("[error]: Need a task number!\n");
                    print_usage();
                    break;
                }
                int task_num = int.parse(argument);
                string[] tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                if (tasks.length == 0) {
                    stdout.printf("The List is empty\n");
                    break;
                }

                storage.task_priority_down(tasks[task_num]);
                tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                print_tasks_list(tasks);
                break;

            case "-del":
                if (argument == null) {
                    stdout.printf("[error]: Need a task number!\n");
                    print_usage();
                    break;
                }

                int task_num = int.parse(argument);
                string[] tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                if (tasks.length == 0) {
                    stdout.printf("The List is empty\n");
                    break;
                }

                storage.delete_task(tasks[task_num]);
                tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                print_tasks_list(tasks);
                break;

            default:
                string[] tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                print_tasks_list(tasks);
                break;
        }
    }

    public static void print_usage() {
        stdout.printf("Usage:\n");
        stdout.printf("\t-h:\t help\n");
        stdout.printf("\t-new:\t New task\n");
        stdout.printf("\t-up:\t Priority Up\n");
        stdout.printf("\t-down:\t Priority Down\n");
        stdout.printf("\t-del:\t Delete Task\n");
    }

    public static void print_tasks_list(string[] tasks) {
        //stdout.printf("Current tasks:\n");
        if (tasks.length == 0) {
            stdout.printf("The List is empty\n");
        }
        else {
            stdout.printf("Current tasks:\n");
            for (int i=0; i<tasks.length; i++) {
                stdout.printf("%s: %s\n", i.to_string(), tasks[i]);
            }
        }
    }
}

public class Storage : GLib.Object {
    private Database db;
    int MAX_PRIORITY_VAL = 3;

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
                    resolved  timestamp NULL DEFAULT NULL,
                    priority  integer NOT NULL DEFAULT 0
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
            WHERE
                resolved IS NULL
            ORDER BY created, priority desc
        """;
        int rc = this.db.prepare_v2(sql, sql.length, out stmt);
        if (rc != Sqlite.OK) {
            stderr.printf("Error while selecting data...");

        }
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

    public void delete_task(string task) {
        string errmsg;
        string sql = """
            DELETE FROM tasks
            WHERE
                task = "%s"
        """.printf(task);

        int rc = this.db.exec(sql, null, out errmsg);
        if (rc != Sqlite.OK) {
            stderr.printf("Database Error: %s\n", errmsg);
        }
    }

    public void resolve_task(string task) {
        string errmsg;
        string sql = """
            UPDATE tasks SET resolved = CURRENT_DATE
            WHERE
                task = "%s"
        """.printf(task);
        int rc = this.db.exec(sql, null, out errmsg);
        if (rc != Sqlite.OK) {
            stderr.printf("Database Error: %s\n", errmsg);
        }
    }

    public int task_priority_up(string task) {
        string errmsg;
        int current_priority = this.get_task_priority(task);
        if (current_priority >= this.MAX_PRIORITY_VAL) {
            return 0;
        }

        string sql = """
            UPDATE tasks SET priority = priority+1
            WHERE
                task = "%s"
        """.printf(task);

        int rc = this.db.exec(sql, null, out errmsg);
        if (rc != Sqlite.OK) {
            stderr.printf("Database Error: %s\n", errmsg);
            return 0;
        }

        return 1;
    }

    public int task_priority_down(string task) {
        string errmsg;
        int current_priority = this.get_task_priority(task);
        if (current_priority == 0) {
            return 0;
        }

        string sql = """
            UPDATE tasks SET priority = priority - 1
            WHERE
                task = "%s"
        """.printf(task);

        int rc = this.db.exec(sql, null, out errmsg);
        if (rc != Sqlite.OK) {
            stderr.printf("Database Error: %s\n", errmsg);
            return 0;
        }

        return 1;
    }

    private int get_task_priority(string task) {
        Statement stmt;
        int priority = 0;

        string sql = """
            SELECT priority FROM tasks
            WHERE
                task = "%s"
        """.printf(task);

        int rc = this.db.prepare_v2(sql, sql.length, out stmt);
        if (rc != Sqlite.OK) {
            stderr.printf("Error while selecting data...");
            return 0;
        }
        while (stmt.step() == Sqlite.ROW) {
            priority = int.parse(stmt.column_text(0));
        }

        return priority;
    }
}
