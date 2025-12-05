file(READ "input.txt" file_contents)
string(REPLACE "\n" ";" lines "${file_contents}")

set(sum 0)

foreach (line IN LISTS lines)
    string(LENGTH "${line}" line_length)
    set(begin 0)
    set(line_sum 0)

    foreach (i RANGE 11)
        math(EXPR end "${line_length} - 11 + ${i}")
        get_max_digit("${line}" ${begin} ${end} digit index)

        math(EXPR line_sum "${line_sum}*10 + ${digit}")
        math(EXPR begin "${index} + 1")
    endforeach ()

    math(EXPR sum "${sum} + ${line_sum}")
endforeach ()

message("Answer to part 2: ${sum}")
