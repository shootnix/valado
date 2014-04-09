// Compile: $ valac --pkg sqlite3 valado.vala
using Sqlite;

public class Task : GLib.Object {
    public int id;
    public string task;

    public Task(int id=0, string task="") {
        this.id = id;
        this.task = task;
    }
}

public class Valado : GLib.Object {

    public static void main(string[] args) {
        Storage storage = new Storage("tasks.db");
        string command  = args[1];
        string argument = args[2];

        int SHOW_RESOLVED_TASKS = 0;

        GLib.stdout.printf("\n");

        switch(command) {
            case "-g":
                int id = int.parse(argument);
                Task task = storage.get_task(id);
                stdout.printf("TASK: %s\n", task.task);
                break;

            case "-h":
                print_usage();
                break;

            case "-add":
                if (argument == null) {
                    GLib.stdout.printf("[error]: Need task value!\n");
                    print_usage();
                    break;
                }
                string task_string = argument;
                storage.create_task(task_string);
                Task[] tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                print_tasks_list(tasks);
                break;

            case "-up":
                if (argument == null) {
                    GLib.stdout.printf("[error]: Need task number!\n");
                    print_usage();
                    break;
                }


                Task[] tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                if (tasks.length == 0) {
                    GLib.stdout.printf("The List is empty\n");
                    break;
                }

                int id = int.parse(argument);
                if (id <= 0) {
                    GLib.stdout.printf("[error]: Need a Natural Number (starts from 0)\n");
                    print_usage();
                    break;
                }

                storage.task_priority_up(id);
                tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                print_tasks_list(tasks);
                break;

            case "-down":
                if (argument == null) {
                    GLib.stdout.printf("[error]: Need a task number!\n");
                    print_usage();
                    break;
                }
                int id = int.parse(argument);
                Task[] tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                if (tasks.length == 0) {
                    GLib.stdout.printf("The List is empty\n");
                    break;
                }

                if (id <= 0) {
                    GLib.stdout.printf("[error]: Need a Natural Number (starts from 0)\n");
                    print_usage();
                    break;
                }

                storage.task_priority_down(id);
                tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                print_tasks_list(tasks);
                break;

            case "-d":
                if (argument == null) {
                    GLib.stdout.printf("[error]: Need a task number!\n");
                    print_usage();
                    break;
                }

                int id = int.parse(argument);
                Task[] tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                if (tasks.length == 0) {
                    GLib.stdout.printf("The List is empty\n");
                    break;
                }

                if (id <= 0) {
                    GLib.stdout.printf("[error]: Need a Natural Number (starts from 0)\n");
                    print_usage();
                    break;
                }

                storage.delete_task(id);
                tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                print_tasks_list(tasks);
                break;

            case "-m":
                if (argument == null) {
                    GLib.stdout.printf("[error]: Need a task number!\n");
                    print_usage();
                    break;
                }

                string marker = argument;
                if (args[3] == null) {
                    stdout.printf("[error]: Need task id\n");
                    print_usage();
                    break;
                }
                int id = int.parse(args[3]);

                if (id <= 0) {
                    GLib.stdout.printf("[error]: Need a Natural Number (starts from 0)\n");
                    print_usage();
                    break;
                }
                Task[] tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);

                storage.task_mark(id, marker);
                tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                print_tasks_list(tasks);

                break;

            case "-um":
                if (argument == null) {
                    GLib.stdout.printf("[error]: Need a task number!\n");
                    print_usage();
                    break;
                }

                string marker = argument;
                if (args[3] == null) {
                    stdout.printf("[error]: Need task id\n");
                    print_usage();
                    break;
                }
                int id = int.parse(args[3]);
                if (id <= 0) {
                    GLib.stdout.printf("[error]: Need a Natural Number (starts from 0)\n");
                    print_usage();
                    break;
                }
                Task[] tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);

                storage.task_unmark(id, marker);
                tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                print_tasks_list(tasks);

                break;

            case "-r":
                if (argument == null) {
                    GLib.stdout.printf("[error]: Need a task number!\n");
                    print_usage();
                    break;
                }

                int id = int.parse(argument);
                if (id <= 0) {
                    GLib.stdout.printf("[error]: Need a Natural Number (starts from 0)\n");
                    print_usage();
                    break;
                }
                Task[] tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);

                storage.resolve_task(id);
                tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                print_tasks_list(tasks);
                break;

            case "-ur":
                if (argument == null) {
                    GLib.stdout.printf("[error]: Need a task number!\n");
                    print_usage();
                    break;
                }

                int id = int.parse(argument);
                if (id <= 0) {
                    GLib.stdout.printf("[error]: Need a Natural Number (starts from 0)\n");
                    print_usage();
                    break;
                }
                Task[] tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);

                storage.unresolve_task(id);
                tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                print_tasks_list(tasks);
                break;

            case "-all":
                Task[] tasks = storage.get_tasks_list(1);
                print_tasks_list(tasks);
                break;

            default:
                Task[] tasks = storage.get_tasks_list(SHOW_RESOLVED_TASKS);
                print_tasks_list(tasks);
                break;
        }
    }

    public static void print_usage() {
        string usage_info = """
        # Show all tasks:
        $ valado

        # Add new task:
        $ valado -add 'Create a new task'

        # Mark task as a resolved:
        $ valado -r [id]

        # Mark task as an unresolved:
        $ valado -ur [id]

        # Delete task
        $ valado -d [id]

        # Priority up:
        $ valado -up [id]

        # Priority down:
        $ valado -down [id]

        # Mark task:
        $ valado -m [marker] [id]

        # Unmark task:
        $ valado -um [marker] [id]
""";

        GLib.stdout.printf("Usage:");
        GLib.stdout.printf(usage_info);
        GLib.stdout.printf("\n");
    }

    public static void print_tasks_list(Task[] tasks) {
        if (tasks.length == 0) {
            GLib.stdout.printf("The List is empty\n");
        }
        else {
            GLib.stdout.printf("Current tasks:\n\n");
            for (int i=0; i<tasks.length; i++) {
                //Storage.Task t = tasks[i];
                GLib.stdout.printf("\t%s: %s\n", tasks[i].id.to_string(), tasks[i].task);
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

    public Task[] get_tasks_list(int show_resolved) {
        Statement stmt;
        Task[] tasks = {};

        string sql = """SELECT id, task, resolved FROM tasks""";
        if (show_resolved == 0) {
            sql += " WHERE resolved IS NULL";
        }
        sql += " ORDER BY priority DESC";

        int rc = this.db.prepare_v2(sql, sql.length, out stmt);
        if (rc != Sqlite.OK) {
            GLib.stderr.printf("Error while selecting data...");

        }
        while (stmt.step() == Sqlite.ROW) {
            string task_str = stmt.column_text(1);
            string resolved_date = stmt.column_text(2);
            if (resolved_date != null) {
                task_str = "\t" + task_str;
            }
            int id = int.parse(stmt.column_text(0));
            Task t = new Task(id, task_str);
            tasks += t;
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

    public bool delete_task(int id) {
        string errmsg;

        string sql = """
            DELETE FROM tasks
            WHERE
                id = %d
        """.printf(id);

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

    public void resolve_task(int id) {
        string errmsg;
        string sql = """
            UPDATE tasks SET resolved = CURRENT_DATE
            WHERE
                id = %d
        """.printf(id);
        int rc = this.db.exec(sql, null, out errmsg);
        if (rc != Sqlite.OK) {
            GLib.stderr.printf("Database Error: %s\n", errmsg);
        }
    }

    public int task_priority_up(int id) {
        string errmsg;
        int current_priority = this.get_task_priority(id);
        if (current_priority >= this.MAX_PRIORITY_VAL) {
            return 0;
        }

        string sql = """
            UPDATE tasks SET priority = priority+1
            WHERE
                id = %d
        """.printf(id);

        int rc = this.db.exec(sql, null, out errmsg);
        if (rc != Sqlite.OK) {
            GLib.stderr.printf("Database Error: %s\n", errmsg);
            return 0;
        }

        return 1;
    }

    public int task_priority_down(int id) {
        string errmsg;
        int current_priority = this.get_task_priority(id);
        if (current_priority == 0) {
            return 0;
        }

        string sql = """
            UPDATE tasks SET priority = priority - 1
            WHERE
                id = %d
        """.printf(id);

        int rc = this.db.exec(sql, null, out errmsg);
        if (rc != Sqlite.OK) {
            GLib.stderr.printf("Database Error: %s\n", errmsg);
            return 0;
        }

        return 1;
    }

    public bool task_unmark(int id, string marker) {
        string stripped = "";
        Regex regex;

        try {
            regex = new Regex("""\%s\s+""".printf(marker));
        }
        catch(RegexError e) {
            GLib.stdout.printf("ERROR: %s\n", e.message);
            return false;
        }

        Task t = get_task(id);
        if (t.task == "") {
            return false;
        }

        try {
            stripped = regex.replace(t.task, t.task.length, 0, "");
        }
        catch(GLib.RegexError e) {
            GLib.stdout.printf("ERROR: %s\n", e.message);
            return false;
        }

        if (stripped == "") {
            return false;
        }

        string errmsg;
        string sql = """
            UPDATE tasks SET task = "%s"
            WHERE id = %d
        """.printf(stripped, id);

        int rc = this.db.exec(sql, null, out errmsg);
        if (rc != Sqlite.OK) {
            GLib.stderr.printf("Database Error: %s\n", errmsg);
            return false;
        }

        return true;
    }

    public bool unresolve_task(int id) {
        string errmsg;
        string sql = """
            UPDATE tasks SET resolved = NULL
            WHERE
                id = %d
        """.printf(id);

        int rc = this.db.exec(sql, null, out errmsg);
        if (rc != Sqlite.OK) {
            GLib.stderr.printf("Database Error: %s\n", errmsg);
            return false;
        }

        return true;
    }

    public bool task_mark(int id, string marker) {
        string errmsg;
        string sql = """
            UPDATE tasks SET task = "%s " || task
            WHERE
                id = %d
        """.printf(marker, id);

        int rc = this.db.exec(sql, null, out errmsg);
        if (rc != Sqlite.OK) {
            GLib.stderr.printf("Database Error: %s\n", errmsg);
            return false;
        }

        return true;
    }

    private int get_task_priority(int id) {
        Statement stmt;
        int priority = 0;

        string sql = """
            SELECT priority FROM tasks
            WHERE
                id = %d
        """.printf(id);

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

        string sql = """SELECT id FROM tasks WHERE task = "%s" AND resolved is NULL""".printf(this.strip_task(task));
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

    public Task get_task(int id) {
        Statement stmt;
        Task[] tasks = {};

        string sql = """SELECT task FROM tasks WHERE id = %d""".printf(id);

        int rc = this.db.prepare_v2(sql, sql.length, out stmt);
        if (rc != Sqlite.OK) {
            GLib.stderr.printf("Error while selecting data...");

        }

        while (stmt.step() == Sqlite.ROW) {
            string task_str = stmt.column_text(0);
            if (task_str == "") {
                stdout.printf("NULL!");
            }

            Task t = new Task(id, task_str);
            tasks += t;
        }

        if (tasks.length == 0) {
            Task t = new Task(0, "");
            tasks += t;
        }

        return tasks[0];
    }
}
