#include <iostream>
#include <cstring>
#include <unistd.h>
#include <fcntl.h>
#include "DBMS.h"

#define NO_BLOCK -1

int DBMS::HashFunction(int value) {
    return value % NUMBER_OF_BUCKETS;
}

DBMS::DBMS(char *filename){
    fp = nullptr;
    controlBlock = new ControlBlock;
    this->filename = filename;

    openFile();

    if (fp != nullptr){
        fseek(fp, 0, SEEK_SET);
        try {
            fread(controlBlock, sizeof(ControlBlock), 1, fp);
            if (strcmp(controlBlock->Relation_scheme, this->RELATION_SCHEME) != 0)
                throw 2;
        }
        catch (int e){
            throw 1;
        }
    } else {

        std::cout << "Cannot open the file, it will be created." << std::endl;
        fp = fopen(filename, "w+b");
        fseek(fp, 0, SEEK_SET);

        initControlBlock();

        saveControlBlockInMem();
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
    this->controlBlock = new ControlBlock;
    memcpy(controlBlock->Relation_scheme, RELATION_SCHEME, sizeof (char[255]));

    for (int i = 0; i < 5; ++i) {
        controlBlock->hashTableFirstBlockOffsets[i] = NO_BLOCK;
        controlBlock->hashTableLastBlockOffsets[i] = NO_BLOCK;
    }
}

void DBMS::saveControlBlockInMem() {
    openFile();
    fseek(fp, 0, SEEK_SET);
    fwrite(controlBlock, sizeof(ControlBlock), 1, fp);
    closeFile();
}

void DBMS::addStudent() {
    int id_zachet, id_gr;
    char surname[30], name[20], patronymic[30];

    std::cout << "Enter id_zachet\n>";
    std::cin >> id_zachet;
    if (getBlockWithIdZachet(id_zachet)){
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


    addZap(zap);

}

/* Инициализирует блок, выдавая ему смещения и номер
 * его бакета
 *
 */
Block * DBMS::initBlock(int bucketNumber) {
    auto* block = new Block;
    memset(block, 0, sizeof(Block));

    block->filled = false;

    Zap *zap = new Zap[5];
    for (int i = 0; i < 5; ++i) {
        zap[i].filled = false;
    }
    //calcualte offset
    openFile();
    fseek(fp, 0, SEEK_END);
    size_t offset = ftell(fp);
    closeFile();
    block->bucketNumber = bucketNumber;
    block->offset = offset;
    block->NextBlockOffset = NO_BLOCK;


    if (controlBlock->hashTableLastBlockOffsets[bucketNumber] != NO_BLOCK) {
        Block* prevBlock = loadBlock(controlBlock->hashTableLastBlockOffsets[bucketNumber]);
        prevBlock->NextBlockOffset = block->offset;
        saveBlockInMem(prevBlock);
        block->PrevBlockOffset = controlBlock->hashTableLastBlockOffsets[bucketNumber];
    }
    else
        block->PrevBlockOffset = NO_BLOCK;

    memcpy(block->Zap_block, zap, sizeof(Zap) * 5);
    return block;

}

void DBMS::addZap(Zap *zap) {
    int bucketNumber = HashFunction(zap->id_zachet);
    if (controlBlock->hashTableLastBlockOffsets[bucketNumber] == NO_BLOCK){
        //если нет блоков вообще
        Block* block = initBlock(bucketNumber);
        block->Zap_block[0] = *zap;
        saveBlockInMem(block);
        controlBlock->hashTableFirstBlockOffsets[bucketNumber] = block->offset;
        controlBlock->hashTableLastBlockOffsets[bucketNumber] = block->offset;
        saveControlBlockInMem();
    } else {
        //если есть - загружаем последний блок и смотрим его
        Block* block =
                loadBlock(controlBlock->hashTableLastBlockOffsets[bucketNumber]);
        int freeZapId = getFreeZapId(block);
        if (freeZapId != -1){
            //есть место под запись - вносим запись
            block->Zap_block[freeZapId] = *zap;
            if (getFreeZapId(block) == -1)
                block->filled = true;
            saveBlockInMem(block);
        } else {
            //создаем новый блок и вносим запись туда
            Block* newBlock = initBlock(bucketNumber);
            block->NextBlockOffset = newBlock->offset;
            saveBlockInMem(block);

            newBlock->Zap_block[0] = *zap;
            saveBlockInMem(newBlock);

            controlBlock->hashTableLastBlockOffsets[bucketNumber] = newBlock->offset;
            saveControlBlockInMem();
        }
    }
}

/*
 * Проверяет все блоки баккета на содержание такой зачетки
 */
Block * DBMS::getBlockWithIdZachet(int id_zachet) {
    int bucketNum = HashFunction(id_zachet);
    int firstOffset = controlBlock->hashTableFirstBlockOffsets[bucketNum];
    if (firstOffset == NO_BLOCK){
        return nullptr;
    }
    Block* block = loadBlock(firstOffset);
    while (true){
        if (getZapIdWithIdZachet(block, id_zachet) != -1)
            return block;

        if (block->NextBlockOffset == NO_BLOCK)
            return nullptr;
        block = loadBlock(block->NextBlockOffset);
    }
}


std::string DBMS::getZapInStr(Zap *zap) {
    std::string answer;
    answer+="{Zap";

    if (!zap->filled)
        answer+=":NOT FILLED}\n";
    else {
        answer += ":FILLED}\n";

        answer += "id_zachet: " +
                  std::to_string(zap->id_zachet) +
                  "\n";
        answer += "id_gr: " +
                  std::to_string(zap->id_gr) +
                  "\n";
        answer += "name: " +
                  std::string(zap->surname) +
                  " " + std::string(zap->name) +
                  " " + std::string(zap->patronymic);
    }
    answer += "\n\n";
    return answer;
}

std::string DBMS::getBlockInStr(Block *block) {
    std::string answer;
    answer+= "[Block";

    if (block->filled){
        answer += ":FILLED]\n\n";
    } else {
        answer += ":NOT FILLED]\n\n";
    }
    for (int i = 0; i < ZAPS_IN_BLOCK; ++i) {
        answer+=getZapInStr(&block->Zap_block[i]);
    }
    answer+="\n\n";
    return answer;
}

std::string DBMS::getAllZapsInStr() {
    openFile();
    std::string answer;
    for (int i = 0; i < NUMBER_OF_BUCKETS; ++i) {
        answer+=getBucketInStr(i);
    }
    closeFile();
    return answer;
}

void DBMS::changeStudentInfo(int id_zachet) {
    Block* block = getBlockWithIdZachet(id_zachet);
    if (block == nullptr){
        std::cout << "Error - no such zaps" << std::endl;
        return;
    }

    int id = getZapIdWithIdZachet(block, id_zachet);
    std::cout << "found:\n"
    << getZapInStr(&block->Zap_block[id]);

    int id_gr;
    char surname[30], name[20], patronymic[30];

    std::cout << "Enter id_gr\n>";
    std::cin >> id_gr;
    std::cout << "Enter surname\n>";
    std::cin >> surname;
    std::cout << "Enter name\n>";
    std::cin >> name;
    std::cout << "Enter patronymic\n>";
    std::cin >> patronymic;

    block->Zap_block[id].id_gr = id_gr;
    strncpy(block->Zap_block[id].surname, surname, 30);
    strncpy(block->Zap_block[id].name, name, 20);
    strncpy(block->Zap_block[id].patronymic, patronymic, 30);

    std::cout << "Success!" << std::endl;
    saveBlockInMem(block);
}

int DBMS::getZapIdWithIdZachet(Block *block, int id_zachet) {
    for (int i = 0; i < ZAPS_IN_BLOCK; ++i) {
        if (block->Zap_block[i].id_zachet == id_zachet)
            return i;
    }
    return -1;
}

Block *DBMS::loadBlock(size_t offset) {
    openFile();
    auto* block = new Block;
    fseek(fp, offset, SEEK_SET);
    fread(block, sizeof(Block), 1, fp);
    closeFile();
    return block;
}

void DBMS::saveBlockInMem(Block *block) {
    openFile();
    fseek(fp, block->offset, SEEK_SET);
    fwrite(block, sizeof(Block), 1, fp);
    closeFile();
}

int DBMS::getFreeZapId(Block *block) {
    for (int i = 0; i < ZAPS_IN_BLOCK; ++i) {
        if (!block->Zap_block[i].filled)
            return i;
    }
    return -1;
}

std::string DBMS::getBucketInStr(int bucketNumber) {
    std::string answer;
    answer+= "Bucket of hash " + std::to_string(bucketNumber) + "\n\n";
    if (controlBlock->hashTableFirstBlockOffsets[bucketNumber] != NO_BLOCK){
        Block* block =
                loadBlock(controlBlock->hashTableFirstBlockOffsets[bucketNumber]);
        answer += getBlockInStr(block);
        while (block->NextBlockOffset != NO_BLOCK){
            block = loadBlock(block->NextBlockOffset);
            answer+=getBlockInStr(block);
        }

    }

    return answer;
}

bool DBMS::blockIsEmpty(Block *block) {
    for (int i = 0; i < ZAPS_IN_BLOCK; ++i) {
        if (block->Zap_block[i].filled)
            return false;
    }
    return true;
}

void DBMS::deleteStudent(int id_zachet) {
    openFile();
    Block* block = getBlockWithIdZachet(id_zachet);

    if (block == nullptr){
        std::cout << "There is no student with such id_zachet" << std::endl;
        return;
    }

    int zapId = getZapIdWithIdZachet(block, id_zachet);

    if (block->offset != controlBlock->hashTableLastBlockOffsets[block->bucketNumber]) {
        Zap *zapToInsert = cutLastZap(block->bucketNumber);
        block->Zap_block[zapId] = *zapToInsert;
        saveBlockInMem(block);
    } else {
        block->Zap_block[zapId].filled = false;
        block->filled = false;
        if (blockIsEmpty(block))
            deleteBlock(block);
        else
            saveBlockInMem(block);
    }

    closeFile();
}

Zap *DBMS::cutLastZap(int bucketNumber) {
    Zap* zap = nullptr;

    openFile();

    Block* block = loadBlock(controlBlock->hashTableLastBlockOffsets[bucketNumber]);


    for (int i = ZAPS_IN_BLOCK - 1; i >= 0; --i) {
        if (block->Zap_block[i].filled){
            zap = new Zap;
            memcpy(zap, &block->Zap_block[i], sizeof(Block));
            block->Zap_block[i].filled = false;
            block->filled = false;
            if (blockIsEmpty(block))
                deleteBlock(block);
            else
                saveBlockInMem(block);
            break;
        }
    }


    closeFile();
    return zap;
}

void DBMS::deleteBlock(Block *blockToDelete) {
    int fd = open(filename, O_RDWR);

    openFile();
    fseek(fp, 0, SEEK_END);
    size_t maxOffset = ftell(fp) - sizeof(Block);
    closeFile();

    if (blockToDelete->offset == maxOffset){
        //у прошлого заменить ссылку
        if (blockToDelete->PrevBlockOffset != NO_BLOCK) {
            Block *prevBlock = loadBlock(blockToDelete->PrevBlockOffset);
            prevBlock->NextBlockOffset = NO_BLOCK;
            saveBlockInMem(prevBlock);
        }
        if (blockToDelete->offset == controlBlock->hashTableFirstBlockOffsets[blockToDelete->bucketNumber]){
            controlBlock->hashTableFirstBlockOffsets[blockToDelete->bucketNumber] = NO_BLOCK;
            saveControlBlockInMem();
        }
        if (blockToDelete->offset == controlBlock->hashTableLastBlockOffsets[blockToDelete->bucketNumber]){
            controlBlock->hashTableLastBlockOffsets[blockToDelete->bucketNumber] = NO_BLOCK;
            saveControlBlockInMem();
        }
        ftruncate(fd, maxOffset);
    } else {
        //берем последний блок
        Block* blockToInsert = loadBlock(maxOffset);
        if (blockToInsert->PrevBlockOffset != NO_BLOCK){
            Block* itsPrevBlock = loadBlock(blockToInsert->PrevBlockOffset);
            itsPrevBlock->NextBlockOffset = blockToDelete->offset;
            saveBlockInMem(itsPrevBlock);
        }
        blockToInsert->offset = blockToDelete->offset;
        saveBlockInMem(blockToInsert);
        ftruncate(fd, maxOffset);

        controlBlock->hashTableLastBlockOffsets[blockToInsert->bucketNumber] = blockToInsert->offset;
        saveControlBlockInMem();
    }


    close(fd);
}





