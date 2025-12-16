#include <iostream>
#include <format>
#include <sstream>

template<size_t n, char c>
constexpr size_t AppendNumber = n * 10 + (c - '0');

template<size_t n, char ... Cs>
struct NumberAppender;

template<size_t n, char c, char ... Cs>
struct NumberAppender<n, c, Cs...> {
    constexpr static size_t value = NumberAppender<AppendNumber<n, c>, Cs...>::value;
};

template<size_t n>
struct NumberAppender<n> {
    constexpr static size_t value = n;
};

template<char ... Cs>
constexpr size_t MakeNumber = NumberAppender<0, Cs...>::value;

template<size_t Value>
struct ID {
    constexpr static size_t value = Value;
};

template<size_t Value>
struct LowerRange {
    constexpr static size_t value = Value;
};

template<size_t Lower, size_t Upper>
struct Range {
    consteval static bool contains(const size_t i) {
        return i >= Lower && i <= Upper;
    }

    static std::string to_string() {
        return std::format("{}-{}", Lower, Upper);
    }
};

template<typename... Rs>
struct RangeList {
    template<size_t Lower, size_t Upper>
    using Append = RangeList<Rs..., Range<Lower, Upper> >;

    template<size_t I>
    consteval static bool contains() {
        return (false || ... || Rs::contains(I));
    }

    static std::string to_string() {
        std::ostringstream ss;
        ((ss << Rs::to_string() << "\n"), ...);
        return ss.str();
    }
};

template<size_t... Is>
struct IdList {
    template<size_t I>
    using Append = IdList<Is..., I>;

    static std::string to_string() {
        std::ostringstream ss;
        ((ss << std::to_string(Is) << "\n"), ...);
        return ss.str();
    }

    template<typename Ranges>
    static constexpr size_t sum_fresh() {
        return (0 + ... + (Ranges::template contains<Is>() ? 1 : 0));
    }
};


template<typename Ranges, typename IdList>
struct Solution {
    constexpr static size_t value = IdList::template sum_fresh<Ranges>();

    static std::string to_string() {
        return std::format("{}\n{}", Ranges::to_string(), IdList::to_string());
    }
};


template<typename Ranges, typename IDs, char ... Cs>
struct ProblemParser {
};

// Lower range (15-15)
template<typename Ranges,
    char l00, char l01, char l02, char l03, char l04, char l05, char l06, char l07, char l08, char l09,
    char l10, char l11, char l12, char l13, char l14,
    char u00, char u01, char u02, char u03, char u04, char u05, char u06, char u07, char u08, char u09,
    char u10, char u11, char u12, char u13, char u14,
    char ... Cs>
struct ProblemParser<Ranges, void,
            l00, l01, l02, l03, l04, l05, l06, l07, l08, l09, l10, l11, l12, l13, l14,
            '-',
            u00, u01, u02, u03, u04, u05, u06, u07, u08, u09, u10, u11, u12, u13, u14,
            '\n', Cs...> {
    using Solution = ProblemParser<
        typename Ranges::template Append<
            MakeNumber<l00, l01, l02, l03, l04, l05, l06, l07, l08, l09, l10, l11, l12, l13, l14>,
            MakeNumber<u00, u01, u02, u03, u04, u05, u06, u07, u08, u09, u10, u11, u12, u13, u14>
        >, void, Cs...
    >::Solution;
};

// Lower range (14-14)
template<typename Ranges,
    char l00, char l01, char l02, char l03, char l04, char l05, char l06, char l07, char l08, char l09,
    char l10, char l11, char l12, char l13,
    char u00, char u01, char u02, char u03, char u04, char u05, char u06, char u07, char u08, char u09,
    char u10, char u11, char u12, char u13,
    char ... Cs>
struct ProblemParser<Ranges, void,
            l00, l01, l02, l03, l04, l05, l06, l07, l08, l09, l10, l11, l12, l13,
            '-',
            u00, u01, u02, u03, u04, u05, u06, u07, u08, u09, u10, u11, u12, u13,
            '\n', Cs...> {
    using Solution = ProblemParser<
        typename Ranges::template Append<
            MakeNumber<l00, l01, l02, l03, l04, l05, l06, l07, l08, l09, l10, l11, l12, l13>,
            MakeNumber<u00, u01, u02, u03, u04, u05, u06, u07, u08, u09, u10, u11, u12, u13>
        >, void, Cs...
    >::Solution;
};

// Lower range (13-13)
template<typename Ranges,
    char l00, char l01, char l02, char l03, char l04, char l05, char l06, char l07, char l08, char l09,
    char l10, char l11, char l12,
    char u00, char u01, char u02, char u03, char u04, char u05, char u06, char u07, char u08, char u09,
    char u10, char u11, char u12,
    char ... Cs>
struct ProblemParser<Ranges, void,
            l00, l01, l02, l03, l04, l05, l06, l07, l08, l09, l10, l11, l12,
            '-',
            u00, u01, u02, u03, u04, u05, u06, u07, u08, u09, u10, u11, u12,
            '\n', Cs...> {
    using Solution = ProblemParser<
        typename Ranges::template Append<
            MakeNumber<l00, l01, l02, l03, l04, l05, l06, l07, l08, l09, l10, l11, l12>,
            MakeNumber<u00, u01, u02, u03, u04, u05, u06, u07, u08, u09, u10, u11, u12>
        >, void, Cs...
    >::Solution;
};

// Space between upper range and IDs
template<typename Ranges, char ... Cs>
struct ProblemParser<Ranges, void, '\n', Cs...> {
    using Solution = ProblemParser<Ranges, IdList<>, Cs...>::Solution;
};

// ID (15)
template<typename Ranges, typename IDs,
    char i00, char i01, char i02, char i03, char i04, char i05, char i06, char i07, char i08, char i09,
    char i10, char i11, char i12, char i13, char i14,
    char ... Cs>
struct ProblemParser<Ranges, IDs,
            i00, i01, i02, i03, i04, i05, i06, i07, i08, i09, i10, i11, i12, i13, i14,
            '\n', Cs...> {
    using Solution = ProblemParser<Ranges,
        typename IDs::template Append<MakeNumber<i00, i01, i02, i03, i04, i05, i06, i07, i08, i09, i10, i11, i12, i13,
            i14> >,
        Cs...>::Solution;
};

// ID (14)
template<typename Ranges, typename IDs,
    char i00, char i01, char i02, char i03, char i04, char i05, char i06, char i07, char i08, char i09,
    char i10, char i11, char i12, char i13,
    char ... Cs>
struct ProblemParser<Ranges, IDs,
            i00, i01, i02, i03, i04, i05, i06, i07, i08, i09, i10, i11, i12, i13,
            '\n', Cs...> {
    using Solution = ProblemParser<Ranges,
        typename IDs::template Append<MakeNumber<i00, i01, i02, i03, i04, i05, i06, i07, i08, i09, i10, i11, i12, i13> >
        ,
        Cs...>::Solution;
};

// ID (13)
template<typename Ranges, typename IDs,
    char i00, char i01, char i02, char i03, char i04, char i05, char i06, char i07, char i08, char i09,
    char i10, char i11, char i12,
    char ... Cs>
struct ProblemParser<Ranges, IDs,
            i00, i01, i02, i03, i04, i05, i06, i07, i08, i09, i10, i11, i12,
            '\n', Cs...> {
    using Solution = ProblemParser<Ranges,
        typename IDs::template Append<MakeNumber<i00, i01, i02, i03, i04, i05, i06, i07, i08, i09, i10, i11, i12> >
        ,
        Cs...>::Solution;
};

// ID (12)
template<typename Ranges, typename IDs,
    char i00, char i01, char i02, char i03, char i04, char i05, char i06, char i07, char i08, char i09,
    char i10, char i11,
    char ... Cs>
struct ProblemParser<Ranges, IDs,
            i00, i01, i02, i03, i04, i05, i06, i07, i08, i09, i10, i11,
            '\n', Cs...> {
    using Solution = ProblemParser<Ranges,
        typename IDs::template Append<MakeNumber<i00, i01, i02, i03, i04, i05, i06, i07, i08, i09, i10, i11> >
        ,
        Cs...>::Solution;
};

template<typename Ranges, typename IDs>
struct ProblemParser<Ranges, IDs, '\n'> {
    using Solution = Solution<Ranges, IDs>;
};

template<char ... Cs>
constexpr size_t solution = ProblemParser<RangeList<>, void, Cs...>::Solution::value;


int main() {
    std::cout << solution<
#embed "test.txt"
    > << std::endl;
    return 0;
}
