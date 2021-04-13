#include <iostream>
#include <cstring>
#include "DBMS.h"
#include "Zap.h"

int DBMS::HashFunction(int value) {
    return value % NUMBER_OF_BUKKITS;
}
//записываем нулевой блок, есть таблица из 5 элтов - нулей, когда добавляем запись - смотрим
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

        saveControlBlockInMem();
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
    this->controlBlock = new ControlBlock;
    memcpy(controlBlock->Relation_scheme, RELATION_SCHEME, sizeof (char[255]));

    for (int i = 0; i < 5; ++i) {
        controlBlock->hashTableFirstBlockOffsets[i] = 0;
        controlBlock->hashTableLastBlockOffsets[i] = 0;
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

/* Инициализирует блок, выдавая ему смещение и номер
 * его бакета
 *
 */
Block * DBMS::initBlock(int bukkitNumber) {
    Block* block = new Block;
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
    block->bukkitNumber = bukkitNumber;
    block->offset = offset;
    block->NextBlockOffset = 0;
    memcpy(block->Zap_block, zap, sizeof(Zap) * 5);
    return block;

}

void DBMS::addZap(Zap *zap) {
    int bukkitNumber = HashFunction(zap->id_zachet);
    if (controlBlock->hashTableLastBlockOffsets[bukkitNumber] == 0){
        //если нет блоков вообще
        Block* block = initBlock(bukkitNumber);
        block->Zap_block[0] = *zap;
        saveBlockInMem(block);
        controlBlock->hashTableFirstBlockOffsets[bukkitNumber] = block->offset;
        controlBlock->hashTableLastBlockOffsets[bukkitNumber] = block->offset;
        saveControlBlockInMem();
    } else {
        //если есть - загружаем последний блок и смотрим его
        Block* block =
                loadBlock(controlBlock->hashTableLastBlockOffsets[bukkitNumber]);
        int freeZapId = getFreeZapId(block);
        if (freeZapId != -1){
            //есть место под запись - вносим запись
            block->Zap_block[freeZapId] = *zap;
            if (getFreeZapId(block) == -1)
                block->filled = true;
            saveBlockInMem(block);
        } else {
            //создаем новый блок и вносим запись туда
            Block* newBlock = initBlock(bukkitNumber);
            block->NextBlockOffset = newBlock->offset;
            saveBlockInMem(block);

            newBlock->Zap_block[0] = *zap;
            saveBlockInMem(newBlock);

            controlBlock->hashTableLastBlockOffsets[bukkitNumber] = newBlock->offset;
            saveControlBlockInMem();
        }
    }
}

/*
 * Проверяет все блоки баккета на содержание такой зачетки
 */
Block * DBMS::getBlockWithIdZachet(int id_zachet) {
    int bukkitNum = HashFunction(id_zachet);
    int firstOffset = controlBlock->hashTableFirstBlockOffsets[bukkitNum];
    if (firstOffset == 0){
        return nullptr;
    }
    Block* block = loadBlock(firstOffset);
    while (true){
        if (getZapIdWithIdZachet(block, id_zachet) != -1)
            return block;

        if (block->NextBlockOffset == 0)
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
    std::string answer;
    for (int i = 0; i < NUMBER_OF_BUKKITS; ++i) {
        answer+=getBukkitInStr(i);
    }
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

std::string DBMS::getBukkitInStr(int bukkitNumber) {
    std::string answer;
    answer+="Bukkit of hash " + std::to_string(bukkitNumber) + "\n\n";
    if (controlBlock->hashTableFirstBlockOffsets[bukkitNumber] != 0){
        Block* block =
                loadBlock(controlBlock->hashTableFirstBlockOffsets[bukkitNumber]);
        answer += getBlockInStr(block);
        while (block->NextBlockOffset != 0){
            block = loadBlock(block->NextBlockOffset);
            answer+=getBlockInStr(block);
        }

    }

    return answer;
}



