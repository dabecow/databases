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

    const int NUMBER_OF_BUKKITS = 10;
    const char RELATION_SCHEME[255] = "Type Zap = recordId_zachet,\n id_gr: integer;\nSurname, Name: string (20);\nPatronymic: string(30);End;\n\nType Block = recordZap_block: array[1..5] of zap; End;";
    const int BLOCKS_IN_BUKKIT = 5;
    const int ZAPS_IN_BLOCK = 5;

    int HashFunction(int value);
    void openFile();
    void closeFile();
    void initControlBlock();
    Zap * getZapWithIdZachet(int id_zachet);
    void initBlock(Block* block);
    bool loadFreeBlockToStoreZap(Zap* zap);
    void loadBlock(size_t offset);
    bool addZap(Zap* zap);

public:
    DBMS(char *filename);
    void addStudent();

};


#endif //LAB_2_DBMS_H
