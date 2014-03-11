// Compile: $ valac --pkg sqlite3 valado.vala
using Sqlite;


public class Valado : GLib.Object {


    public static void main(string[] args) {
        Storage storage = new Storage("tasks.db");
        string command  = args[1];
        string argument = args[2];

        int SHOW_RESOLVED_TASKS = 0;

        GLib.stdout.printf("\n");

        switch(command) {
            case "-h":
                print_usage();
                break;

            case "-add":
                if (argument == null) {
                    GLib.stdout.printf("[error]: Need task value!\n");
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
                    GLib.stdout.printf("[error]: Need task number!\n");
                    print_usage();
                    break;
                }

                int task_num = int.parse(argument);
                string[] tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                if (tasks.length == 0) {
                    GLib.stdout.printf("The List is empty\n");
                    break;
                }

                if (task_num < 0) {
                    GLib.stdout.printf("[error]: Need a Natural Number (starts from 0)\n");
                    print_usage();
                    break;
                }

                if (task_num > tasks.length-1) {
                    GLib.stdout.printf("[error]: Not found task with number #%s\n", task_num.to_string());
                    print_tasks_list(tasks);
                    break;
                }

                storage.task_priority_up(tasks[task_num]);
                tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                print_tasks_list(tasks);
                break;

            case "-down":
                if (argument == null) {
                    GLib.stdout.printf("[error]: Need a task number!\n");
                    print_usage();
                    break;
                }
                int task_num = int.parse(argument);
                string[] tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                if (tasks.length == 0) {
                    GLib.stdout.printf("The List is empty\n");
                    break;
                }

                if (task_num < 0) {
                    GLib.stdout.printf("[error]: Need a Natural Number (starts from 0)\n");
                    print_usage();
                    break;
                }

                if (task_num > tasks.length-1) {
                    GLib.stdout.printf("[error]: Not found task with number #%s\n", task_num.to_string());
                    print_tasks_list(tasks);
                    break;
                }

                storage.task_priority_down(tasks[task_num]);
                tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                print_tasks_list(tasks);
                break;

            case "-d":
                if (argument == null) {
                    GLib.stdout.printf("[error]: Need a task number!\n");
                    print_usage();
                    break;
                }

                int task_num = int.parse(argument);
                string[] tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                if (tasks.length == 0) {
                    GLib.stdout.printf("The List is empty\n");
                    break;
                }

                if (task_num < 0) {
                    GLib.stdout.printf("[error]: Need a Natural Number (starts from 0)\n");
                    print_usage();
                    break;
                }

                if (task_num > tasks.length-1) {
                    GLib.stdout.printf("[error]: Not found task with number #%s\n", task_num.to_string());
                    print_tasks_list(tasks);
                    break;
                }

                storage.delete_task(tasks[task_num]);
                tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                print_tasks_list(tasks);
                break;

            case "-m":
                if (argument == null) {
                    GLib.stdout.printf("[error]: Need a task number!\n");
                    print_usage();
                    break;
                }

                int task_num = int.parse(argument);
                if (task_num < 0) {
                    GLib.stdout.printf("[error]: Need a Natural Number (starts from 0)\n");
                    print_usage();
                    break;
                }
                string[] tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                if (task_num > tasks.length-1) {
                    GLib.stdout.printf("[error]: Not found task with number #%s\n", task_num.to_string());
                    print_tasks_list(tasks);
                    break;
                }

                string marker = args[3];
                if (marker == null) {
                    marker = "*";
                }
                storage.task_mark(tasks[task_num], marker);
                tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                print_tasks_list(tasks);

                break;

            case "-um":
                if (argument == null) {
                    GLib.stdout.printf("[error]: Need a task number!\n");
                    print_usage();
                    break;
                }

                int task_num = int.parse(argument);
                if (task_num < 0) {
                    GLib.stdout.printf("[error]: Need a Natural Number (starts from 0)\n");
                    print_usage();
                    break;
                }
                string[] tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                if (task_num > tasks.length-1) {
                    GLib.stdout.printf("[error]: Not found task with number #%s\n", task_num.to_string());
                    print_tasks_list(tasks);
                    break;
                }

                string marker = args[3];
                if (marker == null) {
                    marker = "*";
                }
                storage.task_unmark(tasks[task_num], marker);
                tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                print_tasks_list(tasks);

                break;

            case "-r":
                if (argument == null) {
                    GLib.stdout.printf("[error]: Need a task number!\n");
                    print_usage();
                    break;
                }

                int task_num = int.parse(argument);
                if (task_num < 0) {
                    GLib.stdout.printf("[error]: Need a Natural Number (starts from 0)\n");
                    print_usage();
                    break;
                }
                string[] tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                if (task_num > tasks.length-1) {
                    GLib.stdout.printf("[error]: Not found task with number #%s\n", task_num.to_string());
                    print_tasks_list(tasks);
                    break;
                }
                storage.resolve_task(tasks[task_num]);
                tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                print_tasks_list(tasks);
                break;

            case "-ur":
                if (argument == null) {
                    GLib.stdout.printf("[error]: Need a task number!\n");
                    print_usage();
                    break;
                }

                int task_num = int.parse(argument);
                if (task_num < 0) {
                    GLib.stdout.printf("[error]: Need a Natural Number (starts from 0)\n");
                    print_usage();
                    break;
                }
                string[] tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                if (task_num > tasks.length-1) {
                    GLib.stdout.printf("[error]: Not found task with number #%s\n", task_num.to_string());
                    print_tasks_list(tasks);
                    break;
                }
                storage.unresolve_task(tasks[task_num]);
                tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                print_tasks_list(tasks);
                break;

            case "-all":
                string[] tasks = storage.get_tasks_list(1);
                print_tasks_list(tasks);
                break;

            default:
                string[] tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                print_tasks_list(tasks);
                break;
        }
    }

    public static void print_usage() {
        GLib.stdout.printf("Usage:\n");
        GLib.stdout.printf("\t-h:\t help\n");
        GLib.stdout.printf("\t-add:\t New task\n");
        GLib.stdout.printf("\t-up:\t Priority Up\n");
        GLib.stdout.printf("\t-down:\t Priority Down\n");
        GLib.stdout.printf("\t-d:\t Delete Task\n");
        GLib.stdout.printf("\t-m:\t Mark Task\n");
        GLib.stdout.printf("\t-r:\t Resolve Task\n");
        GLib.stdout.printf("\t-ur:\t Unresolve Task\n");
        GLib.stdout.printf("\t-all:\t Show all tasks\n");

        GLib.stdout.printf("\n");
    }

    public static void print_tasks_list(string[] tasks) {
        if (tasks.length == 0) {
            GLib.stdout.printf("The List is empty\n");
        }
        else {
            GLib.stdout.printf("Current tasks:\n\n");
            for (int i=0; i<tasks.length; i++) {
                GLib.stdout.printf("\t%s: %s\n", i.to_string(), tasks[i]);
            }
            GLib.stdout.printf("\n\n");
        }
    }
}

public class Storage : GLib.Object {
    private Database db;
    int MAX_PRIORITY_VAL = 3;

    public Storage(string dbfile) {
        int rc;
        string home = GLib.Environment.get_home_dir();
        string workdir = home + "/.valado";
        GLib.DirUtils.create_with_parents(workdir, 0777);
        GLib.FileUtils.chmod(workdir, 0777);
        string dbfile_path = workdir + "/" + dbfile;

        if (!FileUtils.test(dbfile_path, FileTest.IS_REGULAR)) {
            // create new database
            GLib.stdout.printf("Storage: creating a new database `%s`...\n", dbfile_path);
            rc = Database.open(dbfile_path, out this.db);
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
            if (rc != Sqlite.OK) {
                GLib.stderr.printf("Cannot Create a database file\n");
                GLib.Process.exit(0);
            }
        }
        else {
            // use existed databse
            rc = Database.open(dbfile_path, out this.db);
            if (rc != Sqlite.OK) {
                GLib.stderr.printf("Can't open database `%s`", dbfile_path);
            }
        }
    }

    public string[] get_tasks_list(int show_resolved) {
        Statement stmt;
        string[] tasks = {};

        string sql = """SELECT task, resolved FROM tasks""";
        if (show_resolved == 0) {
            sql += " WHERE resolved IS NULL";
        }
        sql += " ORDER BY created, priority DESC";

        int rc = this.db.prepare_v2(sql, sql.length, out stmt);
        if (rc != Sqlite.OK) {
            GLib.stderr.printf("Error while selecting data...");

        }
        while (stmt.step() == Sqlite.ROW) {
            string task = stmt.column_text(0);
            string resolved_date = stmt.column_text(1);
            if (resolved_date != null) {
                task = "<" + task + ">";
            }
            tasks += task;
        }

        return tasks;
    }

    public bool create_task(string task) {
        string errmsg;

        if (this.is_task_exists(task)) {
            GLib.stderr.printf("[error]: Task is already exists: %s\n", task);
            return false;
        }

        string sql = """
            INSERT INTO tasks (task)
            VALUES ("%s");
        """.printf(task);

        int rc = this.db.exec(sql, null, out errmsg);
        if (rc != Sqlite.OK) {
            GLib.stderr.printf("Database Error: %s\n", errmsg);
        }

        return true;
    }

    public bool delete_task(string task) {
        string errmsg;
        string stripped_task = this.strip_task(task);

        string sql = """
            DELETE FROM tasks
            WHERE
                task = "%s"
        """.printf(stripped_task);

        int rc = this.db.exec(sql, null, out errmsg);
        if (rc != Sqlite.OK) {
            GLib.stderr.printf("Database Error: %s\n", errmsg);
            return false;
        }

        return true;
    }

    private string strip_task(string task) {
        Regex regex;
        string stripped = "";

        try {
            regex = new Regex("^<|>$");
        }
        catch(RegexError e) {
            GLib.stdout.printf("ERROR: %s\n", e.message);
            return "";
        }

        try {
            stripped = regex.replace(task, task.length, 0, "");
        }
        catch(GLib.RegexError e) {
            GLib.stdout.printf("ERROR: %s\n", e.message);
            return "";
        }

        return stripped;
    }

    public void resolve_task(string task) {
        string errmsg;
        string sql = """
            UPDATE tasks SET resolved = CURRENT_DATE
            WHERE
                task = "%s"
        """.printf(this.strip_task(task));
        int rc = this.db.exec(sql, null, out errmsg);
        if (rc != Sqlite.OK) {
            GLib.stderr.printf("Database Error: %s\n", errmsg);
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
        """.printf(this.strip_task(task));

        int rc = this.db.exec(sql, null, out errmsg);
        if (rc != Sqlite.OK) {
            GLib.stderr.printf("Database Error: %s\n", errmsg);
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
        """.printf(this.strip_task(task));

        int rc = this.db.exec(sql, null, out errmsg);
        if (rc != Sqlite.OK) {
            GLib.stderr.printf("Database Error: %s\n", errmsg);
            return 0;
        }

        return 1;
    }

    public bool task_unmark(string task, string marker) {
        string stripped = "";
        Regex regex;

        try {
            regex = new Regex("""^\%s\s+|\%s\s+$""".printf(marker, marker));
        }
        catch(RegexError e) {
            GLib.stdout.printf("ERROR: %s\n", e.message);
            return false;
        }

        try {
            stripped = regex.replace(task, task.length, 0, "");
        }
        catch(GLib.RegexError e) {
            GLib.stdout.printf("ERROR: %s\n", e.message);
            return false;
        }

        string errmsg;
        string sql = """
            UPDATE tasks SET task = "%s"
            WHERE task = "%s"
        """.printf(stripped, task);

        int rc = this.db.exec(sql, null, out errmsg);
        if (rc != Sqlite.OK) {
            GLib.stderr.printf("Database Error: %s\n", errmsg);
            return false;
        }

        return true;
    }

    public bool unresolve_task(string task) {
        string errmsg;
        string sql = """
            UPDATE tasks SET resolved = NULL
            WHERE
                task = "%s"
        """.printf(this.strip_task(task));

        int rc = this.db.exec(sql, null, out errmsg);
        if (rc != Sqlite.OK) {
            GLib.stderr.printf("Database Error: %s\n", errmsg);
            return false;
        }

        return true;
    }

    public bool task_mark(string task, string marker) {
        string errmsg;
        string sql = """
            UPDATE tasks SET task = "%s " || task
            WHERE
                task = "%s"
        """.printf(marker, this.strip_task(task));

        int rc = this.db.exec(sql, null, out errmsg);
        if (rc != Sqlite.OK) {
            GLib.stderr.printf("Database Error: %s\n", errmsg);
            return false;
        }

        return true;
    }

    private int get_task_priority(string task) {
        Statement stmt;
        int priority = 0;

        string sql = """
            SELECT priority FROM tasks
            WHERE
                task = "%s"
        """.printf(this.strip_task(task));

        int rc = this.db.prepare_v2(sql, sql.length, out stmt);
        if (rc != Sqlite.OK) {
            GLib.stderr.printf("Error while selecting data...");
            return 0;
        }
        while (stmt.step() == Sqlite.ROW) {
            priority = int.parse(stmt.column_text(0));
        }

        return priority;
    }

    private bool is_task_exists(string task) {
        Statement stmt;

        string sql = """SELECT id FROM tasks WHERE task = "%s"""".printf(this.strip_task(task));
        int rc = this.db.prepare_v2(sql, sql.length, out stmt);
        if (rc != Sqlite.OK) {
            GLib.stderr.printf("Database Error");
            return false;
        }

        int[] data = {};
        while (stmt.step() == Sqlite.ROW) {
            data += int.parse(stmt.column_text(0));
        }

        return (data.length == 0) ? false : true;
    }
}
