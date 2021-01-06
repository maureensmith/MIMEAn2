cmake_minimum_required(VERSION 3.10)
project(MIMEAn2
        VERSION 0.1.0
        DESCRIPTION "MIME Analysis Tool 2: Evaluate MIME experiment data and infer signficant effects on the RNA function."
        LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)

add_subdirectory(src)

add_executable(MIMEAn2
        src/main.cpp)

target_link_libraries(MIMEAn2 MIMEAn2Lib)
