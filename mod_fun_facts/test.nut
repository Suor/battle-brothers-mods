local function b(x) {
    return x + 2;
}

local function a() {
    print(b(10));
}

a();

// local thing = {
//     Prop = [3 5 7]
//     function test() {
//         print(this.Prop.len());
//         local prop = this.Prop;
//         local xs = [0 1 2 3 4 5 6 7].filter(@(_, x) prop.find(x) == null);
//         print(xs.len());
//     }
// }

// thing.test();
