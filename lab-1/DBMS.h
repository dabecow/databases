#include "fstream"
#include "ControlBlock.h"

#ifndef LAB_1_DBMS_H
#define LAB_1_DBMS_H



class DBMS {
    FILE *fp;
    char* filename;
    Block* currentBlock;
    const int BLOCK_LENGTH = 5;
    const char CHECK_SUM[10] = "123456789";
    ControlBlock *controlBlock;
    bool saved;

private:
    void saveControlBlockInMem();
    bool isControlBlockCorrect();
    void initControlBlock();
//    bool blockIsFull(Block* block);
    void loadNextBlock();
//    Block* loadNextBlock();
    Block* addNewBlock();
    void initBlock(Block *block);
    void saveBlockInMem(Block *block);
    int getFreeZapId(Block* block);
    void loadBlock(int blockId);
    bool loadFreeBlock();
    int getZapIdWithIdZachet(int id_zachet);
    void openFile();
    void closeFile();
    void addZapToBlock(Zap* zap, Block* block);
    bool blockIsEmpty(Block* block);
//    int getEmptyBlockId();
//    bool deleteEmptyBlock(int blockId);
//    int getBlockIdCanMoveZaps();
//    void moveZapsToFreeSpace();
    Zap* cutLastZap();
//    void rearrangeBlocks();
    void deleteLastBlockFromMem();

public:
    std::string getZapInStr(Zap* zap);
    std::string getBlockInStr(Block* block);
    std::string getAllZapsInStr();
    void saveChanges();
    void addStudent();
    DBMS(char* fileName);
    void addZap(Zap *zap);
    void changeZapInfo(int id_zachet);
    void deleteZap(int id_zachet);

};


#endif //LAB_1_DBMS_H
