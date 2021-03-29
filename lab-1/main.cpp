#include <iostream>
#include "DBMS.h"

void showMenu(){
    std::cout << "1. Add student\n"
                 "2. Change student info\n"
                 "3. Delete student\n"
                 "4. Get students info\n"
                 "5. Quit" << std::endl;
}

char getChoice(){
    std::cout << ">>>";
    char choice;
    std::cin >> choice;
    return choice;
}

int main(int argc, char* argv[]) {

    if(argc < 2) {
        std::cout << "Usage: DBMS <file name>" << std::endl;
        return 1;
    }

    try {
        DBMS dbms(argv[1]);
//        DBMS dbms("db");
        while (true){
            showMenu();
            switch (getChoice()){
                case '1':
                    dbms.addStudent();
                    break;
                case '2': {
                    std::cout << "Enter the id_zachet value\n>";
                    int id_zachet;
                    std::cin >> id_zachet;
                    dbms.changeZapInfo(id_zachet);
                }
                    break;
                case '3': {
                    std::cout << "Enter the id_zachet value\n>";
                    int id_zachet;
                    std::cin >> id_zachet;
                    dbms.deleteZap(id_zachet);
                }
                    break;
                case '4':
                    std::cout << dbms.getAllZapsInStr();
                    break;
                case '5':
                    dbms.saveChanges();
                    return 0;
                default:
                    std::cout << "Wrong command, please, try again" << std::endl;
                    break;
            }
        }

    } catch (int e) {
        std::cout << "The file is not a compatible DB";
        return 1;
    }
}
