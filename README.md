README
======

Valado - simple tiny TODO-list program to make your todo-list written in Vala and uses sqlite3 database.

USAGE
=====

    # Show all tasks:
    $ valado

    # Add new task:
    $ valado -add 'Create a new task'

    # Mark task as a resolved:
    $ valado -r [number]

    # Mark task as an unresolved:
    $ valado -ur [number]

    # Delete task
    $ valado -d [number]

    # Priority up:
    $ valado -up [number]

    # Priority down:
    $ valado -down [number]

    # Mark task:
    $ valado -m [number]

    # Unmark task:
    $ valado -um [number]

LICENSE
=======

BSD.