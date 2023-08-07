local o = {
    id = "o"
    function onTargetHit (a, b) {
        print(this.id + ": " + a + " " + b + "\n");
    }
}

function l(p) {
    return p + 1;
}

local x = {
    id = "x"
    ll = l(100)
    l2 = l(200)
    // function onTargetHit (a, b) {
    //     print("x.onTargetHit id = " + this.id + ": " + a + " " + b + "\n");
    // }
}

local arr = [1 2 3 4 5];

foreach (x in arr) print(x + "\n")

// local ll = arr
//     .filter(@(_, x) x > 3)
//     .map(@(x) x * 10);
// print(ll[0]);

// print(x.l2)
// local onTargetHit = o.onTargetHit;
// o.onTargetHit = function(...) {
//     vargv.insert(0, this);
//     local ret = onTargetHit.acall(vargv);

//     local funFacts = x;
//     vargv[0] = funFacts;
//     funFacts.onTargetHit.acall(vargv);

//     return ret;
// }

// o.onTargetHit(50 20);
