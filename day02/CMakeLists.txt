cmake_minimum_required(VERSION 3.28)
project(aoc2025_day02)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

add_compile_options(-fbracket-depth=82068)
add_executable(part1 part1.cpp)
add_executable(part2 part2.cpp)
