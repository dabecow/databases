//
// Created by antom on 29.03.2021.
//

#ifndef LAB_2_DBMS_H
#define LAB_2_DBMS_H


#include <cstdio>
#include "ControlBlock.h"
#include "Zap.h"

class DBMS {

private:
    FILE *fp;
    char* filename;
    ControlBlock* controlBlock;
    bool saved;
    Block* currentBlock;

    const int NUMBER_OF_BUKKITS = 5;
    const char RELATION_SCHEME[255] = "Type Zap = recordId_zachet,\n id_gr: integer;\nSurname, Name: string (20);\nPatronymic: string(30);End;\n\nType Block = recordZap_block: array[1..5] of zap; End;";
    const int ZAPS_IN_BLOCK = 5;

    void initControlBlock();
    void saveControlBlockInMem();
    int HashFunction(int value);
    void openFile();
    void closeFile();
    Block* initBlock(int bukkitNumber);
    void addZap(Zap* zap);
    Block* loadBlock(size_t offset);
    Block * getBlockWithIdZachet(int id_zachet);
    int getZapIdWithIdZachet(Block* block, int id_zachet);
    void saveBlockInMem(Block* block);
    int getFreeZapId(Block* block);
public:
    DBMS(char *filename);
    std::string getBukkitInStr(int bukkitNumber);
    std::string getZapInStr(Zap* zap);
    std::string getBlockInStr(Block* block);
    std::string getAllZapsInStr();
    void addStudent();
    void changeStudentInfo(int id_zachet);
    void deleteStudent(int id_zachet);
};


#endif //LAB_2_DBMS_H
