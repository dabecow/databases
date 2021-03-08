//
// Created by Andrew on 03.03.2021.
//
#include "fstream"
#include "ControlBlock.h"

#ifndef LAB_1_DBMS_H
#define LAB_1_DBMS_H



class DBMS {
    FILE *fp;
    Block* currentBlock;
    const int BLOCK_LENGTH = 5;
    const char CHECK_SUM[10] = "123456789";
    ControlBlock *controlBlock;

private:
    void saveControlBlockInMem();
    bool isControlBlockCorrect();
    void initControlBlock();
    bool blockIsFull(Block* block);
    Block* loadNextBlock();
    Block* addNewBlock();
    void initBlock(Block *block);
    void saveCurrentBlockInMem(Block *block);
    int getFreeZapId(Block* block);
    void loadBlock(int blockId);
    int getZapIdWithIdZachet(int id_zachet);

public:
    std::string getAllZapsInStr();
    void saveChanges();
    void addStudent();
    DBMS(char* fileName);
    void addZap(Zap *zap);
    void changeZapInfo(int id_zachet);
    void deleteZap(int id_zachet);
//    Zap* findZap(int id);

};


#endif //LAB_1_DBMS_H
