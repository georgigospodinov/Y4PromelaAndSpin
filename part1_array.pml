#define N 4
bool s[N];
byte x = 1;

active [N] proctype P() {
    pid me = _pid;

    // Only processes with indexes 1 to 3 should run.
    if
    :: me == 0 -> goto leave_critical;
    :: else -> skip;
    fi

    // Wait until x says that it's my turn.
    me == x;

    // Now that it's my turn, wait until all s are false.
    // Note that only one instance will be here at any one time.
    byte i;
    wait_release:
    for (i : 1 .. (N-1)) {
        if
        :: s[i] -> goto wait_release;
        :: else -> skip;
        fi
    }

    // Critical section.
    s[me] = true;
    if
    :: x+1 == N -> x = 1;
    :: else -> x = x+1;
    fi

    leave_critical:
    s[me] = false;
}

active proctype Checker() {
    int i, j;
    do
    :: atomic {
        for (i : 0 .. (N-1)) {
            for (j : i .. (N-1)) {
                if
                :: i != j -> assert(!s[i] || !s[j]);
                :: else -> skip;
                fi
            }
        }
    }
    od
}
