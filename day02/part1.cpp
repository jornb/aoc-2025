#include <iostream>

template<size_t n, char c>
constexpr size_t AppendNumber = n * 10 + (c - '0');


constexpr size_t get_num_digits(size_t n) {
    if (n >= 100000000000) return 12;
    if (n >= 10000000000) return 11;
    if (n >= 1000000000) return 10;
    if (n >= 100000000) return 9;
    if (n >= 10000000) return 8;
    if (n >= 1000000) return 7;
    if (n >= 100000) return 6;
    if (n >= 10000) return 5;
    if (n >= 1000) return 4;
    if (n >= 100) return 3;
    if (n >= 10) return 2;
    return 1;
}

template<size_t n>
constexpr static size_t pow10() {
    if constexpr (n == 0)
        return 1;
    else
        return 10 * pow10<n - 1>();
}


template<size_t Id>
constexpr bool is_invalid() {
    constexpr size_t num_digits = get_num_digits(Id);
    if constexpr (num_digits == 1 || num_digits % 2 != 0) {
        return false;
    } else {
        constexpr auto p0 = Id / pow10<num_digits / 2>();
        constexpr auto p1 = Id % pow10<num_digits / 2>();
        return p0 == p1;
    }
}

template<size_t Lower, size_t... Is>
constexpr size_t sum_invalid_impl(std::index_sequence<Is...>) {
    return (0 + ... + (is_invalid<Lower + Is>() ? (Lower + Is) : 0));
}

template<size_t Lower, size_t Upper>
constexpr size_t sum_invalid_in_range() {
    if constexpr (Upper < Lower) return 0;
    return sum_invalid_impl<Lower>(std::make_index_sequence<Upper - Lower + 1>{});
}


template<size_t Result, bool IsLower, size_t Lower, size_t Upper, char ... Cs>
struct ProblemSolver;

// Last character
template<size_t Result, bool IsLower, size_t Lower, size_t Upper, char c>
struct ProblemSolver<Result, IsLower, Lower, Upper, c> {
    constexpr static size_t value = Result + sum_invalid_in_range<Lower, AppendNumber<Upper, c> >();
};

// Regular case
template<size_t Result, bool IsLower, size_t Lower, size_t Upper, char c, char ... Cs>
struct ProblemSolver<Result, IsLower, Lower, Upper, c, Cs...> {
    constexpr static size_t evaluate() {
        if constexpr (c == '-') {
            return ProblemSolver<Result, false, Lower, Upper, Cs...>::value;
        } else if constexpr (c == ',') {
            return ProblemSolver<Result + sum_invalid_in_range<Lower, Upper>(), true, 0, 0, Cs...>::value;
        } else if constexpr (IsLower) {
            return ProblemSolver<Result, true, AppendNumber<Lower, c>, Upper, Cs...>::value;
        } else {
            return ProblemSolver<Result, false, Lower, AppendNumber<Upper, c>, Cs...>::value;
        }
    }

    constexpr static size_t value = evaluate();
};

template<char ... Cs>
constexpr static auto solution = ProblemSolver<0, true, 0, 0, Cs...>::value;

int main() {
    std::cout << solution<
#embed "test.txt"
    > << std::endl;
    return 0;
}
