#include <iostream>
#include <cstring>
#include "DBMS.h"
#include "Zap.h"

int DBMS::HashFunction(int value) {
    return value / 10;
}

DBMS::DBMS(char *filename){
    fp = nullptr;
    controlBlock = new ControlBlock;
    this->filename = filename;
    this->saved = true;

    openFile();

    if (fp != nullptr){
        fseek(fp, 0, SEEK_SET);
        try {
            fread(controlBlock, sizeof(ControlBlock), 1, fp);
            if (strcmp(controlBlock->Relation_scheme, this->RELATION_SCHEME) != 0)
                throw 2;
//            if (controlBlock->blocksAmount >=0)
//                loadBlock(0);
        }
        catch (int e){
            throw 1;
        }
    } else {
//        saved = false;

        std::cout << "Cannot open the file, it will be created." << std::endl;
        fp = fopen(filename, "w+b");
        fseek(fp, 0, SEEK_SET);

        initControlBlock();

        fwrite(controlBlock, sizeof(ControlBlock), 1, this->fp);
//        if (controlBlock->blocksAmount != 0)
//            loadNextBlock();
    }

    closeFile();
}

void DBMS::openFile(){
    if (fp == nullptr)
        fp = fopen(filename, "r+b");
}

void DBMS::closeFile() {
    if (fp != nullptr)
        fclose(fp);
    fp = nullptr;
}

void DBMS::initControlBlock() {
    auto* cb = new ControlBlock;
    strcpy(cb->Relation_scheme, RELATION_SCHEME);
    for (int i = 0; i < 10; ++i) {
        cb->hashTableOffsets[i] =  sizeof(ControlBlock) + sizeof(Block) * BLOCKS_IN_BUKKIT;

    }
}

void DBMS::addStudent() {
    int id_zachet, id_gr;
    char surname[30], name[20], patronymic[30];

    std::cout << "Enter id_zachet\n>";
    std::cin >> id_zachet;
    if (getZapWithIdZachet(id_zachet) != nullptr){
        std::cout << "Error - There is already zap with this id_zachet" << std::endl;
        return;
    }

    std::cout << "Enter id_gr\n>";
    std::cin >> id_gr;
    std::cout << "Enter surname\n>";
    std::cin >> surname;
    std::cout << "Enter name\n>";
    std::cin >> name;
    std::cout << "Enter patronymic\n>";
    std::cin >> patronymic;

    Zap* zap = new Zap;
    zap->filled = true;
    zap->id_zachet = id_zachet;
    zap->id_gr = id_gr;
    strncpy(zap->surname, surname, 30);
    strncpy(zap->name, name, 20);
    strncpy(zap->patronymic, patronymic, 30);

    if (loadFreeBlockToStoreZap(zap))
        addZap(zap);
    else std::cout << "Error - no free space for such zap" << std::endl;
}

Zap * DBMS::getZapWithIdZachet(int id_zachet) {
    openFile();
    
    size_t offset = HashFunction(id_zachet) * sizeof(Block) * BLOCKS_IN_BUKKIT;


    for (int i = 0; i < BLOCKS_IN_BUKKIT; ++i) {
        loadBlock(offset);
        for (int j = 0; j < ZAPS_IN_BLOCK; ++j) {
            if (currentBlock->Zap_block[j].id_zachet == id_zachet) {
                closeFile();
                return &currentBlock->Zap_block[j];
            }
        }
    }
    
    
    closeFile();
    return nullptr;
}

void DBMS::initBlock(Block *block) {
    memset(block, 0, sizeof(Block));
//    block->id = controlBlock->blocksAmount;
    block->filled = false;

    Zap *zap = new Zap[5];
    for (int i = 0; i < 5; ++i) {
        zap[i].filled = false;
    }
    memcpy(block->Zap_block, zap, sizeof(Zap) * 5);
}

bool DBMS::loadFreeBlockToStoreZap(Zap *zap) {
    openFile();
    size_t offset = HashFunction(zap->id_zachet) * sizeof(Block) * BLOCKS_IN_BUKKIT;
    for (int i = 0; i < BLOCKS_IN_BUKKIT; ++i) {
        offset +=sizeof(Block);
        loadBlock(offset);
        if (!currentBlock->filled)
            return true;
    }

    return false;
}

void DBMS::loadBlock(size_t offset) {
    openFile();

    fseek(fp, offset, SEEK_SET);
    fread(currentBlock, sizeof(Block), 1, fp);

    closeFile();
}
