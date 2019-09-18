#define N 100
bool print[N];
bool turnSet = false;
int turn = N/2;

active [N] proctype P() {
    pid me = _pid;

    wait_turn:
    turnSet && me == turn;

    // State printing.
    print[me] = true;
    printf("Now P%d can print!\n", me);
    print[me] = false;
    turnSet = false;
    do
    :: turn < (N-1) -> turn++;
    :: turn > 0 -> turn--;
    :: 0 <= turn && turn < N -> break;
    od
    turnSet = true;

    // Repeat infinetely often.
    goto wait_turn;
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

init {
    do
    :: turn++;
    :: turn--;
    :: turn >= 0 && turn < N -> break;
    od
    turnSet = true;
}
