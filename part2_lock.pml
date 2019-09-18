#define N 100
bool print[N];
int lock = 0;

active [N] proctype P() {
    pid id = _pid;

    wait_release:
    // Grab the lock.
    lock++;

    // If someone else already had it, release the lock.
    if
    :: lock != 1 ->
        lock--;
        goto wait_release;
    :: else -> skip;
    fi

    // Printing (critical section).
    print[id] = true;
    printf("Now P%d can print!\n", id);
    print[id] = false;

    lock--;
    // Repeat infinetely often.
    goto wait_release;
}

active proctype Checker() {
    int i, j;
    do
    :: atomic {
        for (i : 0 .. (N-1)) {
            for (j : i .. (N-1)) {
                if
                :: i != j -> assert(!print[i] || !print[j]);
                :: else -> skip;
                fi
            }
        }
    }
    od
}
