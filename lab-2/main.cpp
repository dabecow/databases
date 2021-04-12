#include <iostream>
#include "DBMS.h"


char printMenuGetChoice(){
    char choice;
    std::cout << "1. Add student\n"
    << "2. Edit zap\n"
    << "3. Delete zap\n"
    << "4. Get all students\n"
    << "q. Quit\n"
    << ">>>";

    std::cin >> choice;
    return choice;
}

int main(int argc, char *argv[]) {

    if(argc < 2) {
        std::cout << "Usage: DBMS <file name>" << std::endl;
        return 1;
    }

    try {
        DBMS dbms(argv[1]);

        char choice;

        while ((choice = printMenuGetChoice()) != 'q'){
            switch (choice) {
                case '1':
                    dbms.addStudent();
                    //add student
                break;
                case '2':{
                    std::cout << "Enter the id_zachet value\n>";
                    int id_zachet;
                    std::cin >> id_zachet;
                    dbms.changeStudentInfo(id_zachet);
                }
                    break;
                case '3':
                    //delete zap
                    break;
                case '4':
                    std::cout << dbms.getAllZapsInStr();
                    break;
            }
        }
    } catch (int e) {
        std::cout << "An error occurred" << std::endl;
    }
    return 0;
}
