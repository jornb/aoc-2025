file(READ "test.txt" file_contents)
string(REPLACE "\n" ";" lines "${file_contents}")

function(get_max_digit str begin end out_var_digit out_var_index)
    string(LENGTH "${str}" str_len)

    set(idx ${begin})
    set(max_index ${begin})
    set(max_digit -1)
    while (${idx} LESS ${end})
        string(SUBSTRING "${str}" ${idx} 1 ch)
        if (NOT "${ch}" STREQUAL "")
            math(EXPR val "${ch}")
            if (val GREATER max_digit)
                set(max_index ${idx})
                set(max_digit ${val})
            endif ()
        endif ()
        math(EXPR idx "${idx} + 1")
    endwhile ()

    set(${out_var_index} ${max_index} PARENT_SCOPE)
    set(${out_var_digit} ${max_digit} PARENT_SCOPE)
endfunction()

set(sum 0)
foreach (line IN LISTS lines)
    string(LENGTH "${line}" line_length)
    math(EXPR last_index "${line_length} - 1")
    get_max_digit("${line}" 0 ${last_index} first_digit first_index)

    math(EXPR first_index "${first_index} + 1")
    get_max_digit("${line}" ${first_index} ${line_length} second_digit first_index)

    math(EXPR sum "${sum} + ${first_digit} * 10 + ${second_digit}")
endforeach ()

message("Answer to part 1: ${sum}")
