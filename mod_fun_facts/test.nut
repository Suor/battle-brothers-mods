// local x = 0, y = 0;

function main (x) {
    local function hey(p) {
        x++;
        print(p + " " + x + "\n");
    }

    hey("there")
    hey("bye")
    hey("foo")
}


main(10);
