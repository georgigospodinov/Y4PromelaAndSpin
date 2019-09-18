bool s1, s2, s3;
mtype = {one,two,three};
mtype x = one;

active proctype P1() {
    start1:
    !s1 && !s2 && !s3 && x == one;
    s1 = true;
    x = two;
    s1 = false;

    goto start1;
}

active proctype P2() {
    start2:
    !s1 && !s2 && !s3 && x == two;
    s2 = true;
    x = three;
    s2 = false;

    goto start2;
}
active proctype P3() {
    start3:
    !s1 && !s2 && !s3 && x == three;
    s3 = true;
    x = one;
    s3 = false;

    goto start3;
}

active proctype Checker() {
    do
    :: atomic {
        assert(!s1 || !s2);
        assert(!s2 || !s3);
        assert(!s3 || !s1);
    }
    od
}
