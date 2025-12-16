cmake_minimum_required(VERSION 3.22)
project(aoc2025_day05)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

add_compile_options(-fbracket-depth=25600 -ftemplate-depth=102400)
add_executable(part1 part1.cpp)
