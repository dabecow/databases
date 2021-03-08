cmake_minimum_required(VERSION 3.15)
project(lab_1)

set(CMAKE_CXX_STANDARD 14)

add_executable(lab_1 main.cpp Zap.h DBMS.cpp DBMS.h ControlBlock.h)