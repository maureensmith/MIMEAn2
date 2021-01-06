set(HEADER_LIST
        Parameter.hpp)

set(SOURCE_LIST
        Parameter.cpp)

# CMake instructions to make the static lib
add_library(MIMEAn2Lib STATIC ${SOURCE_LIST} ${HEADER_LIST})

#for g++-9 this is not necessary, but it is for g++-8
target_link_libraries(MIMEAn2Lib stdc++fs)


