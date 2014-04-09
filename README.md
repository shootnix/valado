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
    $ valado -r [#id]

    # Mark task as an unresolved:
    $ valado -ur [#id]

    # Delete tasks:
    $ valado -d [#id]

    # Priority up:
    $ valado -up [#id]

    # Priority down:
    $ valado -down [#id]

    # Mark task:
    $ valado -m [*marker*] [#id]

    # Unmark task:
    $ valado -um [*marker*] [#id]

LICENSE
=======

This is free software at all. Good luck ;-)
