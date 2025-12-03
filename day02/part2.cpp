#include <iostream>
#include <fstream>
#include <sstream>


bool is_invalid(const size_t num_digits, const std::string &id) {
    if (id.size() % num_digits != 0) {
        return false;
    }

    for (size_t i = num_digits; i < id.size(); i += num_digits) {
        if (id.substr(0, num_digits) != id.substr(i, num_digits)) {
            return false;
        }
    }

    return true;
}

bool is_invalid(const size_t id) {
    const std::string s = std::to_string(id);

    for (size_t n = 1; n <= s.size() / 2; ++n) {
        if (is_invalid(n, s)) {
            return true;
        }
    }

    return false;
}

int main() {
    std::ifstream input_file{"input.txt"};
    std::stringstream buffer;
    buffer << input_file.rdbuf();
    const auto input = buffer.str();

    size_t result = 0;

    size_t i = 0;
    while (true) {
        auto it_dash = input.find('-', i);
        auto it_comma = input.find(',', i);

        auto s1 = input.substr(i, it_dash - i);
        auto s2 = input.substr(it_dash + 1, it_comma - it_dash - 1);
        i = it_comma + 1;

        const auto n1 = std::stoull(s1);
        const auto n2 = std::stoull(s2);
        for (size_t n = n1; n <= n2; ++n) {
            if (is_invalid(n))
                result += n;
        }

        if (it_comma == std::string::npos) {
            break;
        }
    }

    std::cout << result << std::endl;
    return 0;
}
