#include <cstring>
#include "DBMS.h"
#include "Zap.h"
#include "iostream"

DBMS::DBMS(char* filename) {
    controlBlock = new ControlBlock;
    currentBlock = new Block;
//todo bug
    if((fp=fopen(filename, "r+t"))== nullptr) {

        fseek(fp, 0, SEEK_SET);
        std::cout << "Cannot open the file, it will be created." << std::endl;
        fp = fopen(filename, "w+");

        initControlBlock();

        fwrite(controlBlock, sizeof(ControlBlock), 1, this->fp);
        if (controlBlock->blocksAmount != 0)
            loadNextBlock();
    }
    else {
        fseek(fp, 0, SEEK_SET);

        try {
            fread(controlBlock, sizeof(ControlBlock), 1, fp);
            if (!isControlBlockCorrect())
                throw 20;
            if (controlBlock->blocksAmount >=0)
                loadBlock(0);

        }
        catch (int e){
            throw 30;
        }
    }
}

void DBMS::initControlBlock() {
    this->controlBlock = new ControlBlock;
    controlBlock->blockLengthInZaps = BLOCK_LENGTH;
    memcpy(controlBlock->checksum, CHECK_SUM, sizeof(char[10]));
    controlBlock->blocksAmount = 0;
    controlBlock->sizeOfBlock = sizeof(Block);
}

void DBMS::initBlock(Block *block) {
    block->id = controlBlock->blocksAmount;
    block->full = false;

    Zap *zap = new Zap[5];
    for (int i = 0; i < 5; ++i) {
        zap[i].free = true;
    }
    memcpy(block->zap_block, zap, sizeof(Zap) * 5);
}



Block *DBMS::addNewBlock() {
    auto* block = new Block;
    initBlock(block);
    controlBlock->blocksAmount+=1;
//    currentBlock = block;
//    saveChanges();
    return block;
}


int DBMS::getFreeZapId(Block* block) {
    for (int i = 0; i < BLOCK_LENGTH; ++i) {
        if (block->zap_block[i].free)
            return i;
    }
    return -1;
}

void DBMS::addZap(Zap *zap) {

    if (controlBlock->blocksAmount == 0 || blockIsFull(currentBlock)) {
        currentBlock = addNewBlock();
        currentBlock->zap_block[0] = *zap;
        saveChanges();
    } else if (!blockIsFull(currentBlock)){
        currentBlock->zap_block[getFreeZapId(currentBlock)] = *zap;
        saveChanges();
    }

}

void DBMS::changeZapInfo(int id_zachet) {
    int id = getZapIdWithIdZachet(id_zachet);
    if (id < 0){
        std::cout << "Error - no student with this id_zachet" << std::endl;
        return;
    }

    int id_gr;
    char surname[30], name[20], patronymic[30];

    std::cout << "Enter id_zachet\n>";
    std::cin >> id_zachet;
    if (getZapIdWithIdZachet(id_zachet) != -1){
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
    zap->free = false;
    zap->id_zachet = id_zachet;
    zap->id_gr = id_gr;
    strncpy(zap->surname, surname, 30);
    strncpy(zap->name, name, 20);
    strncpy(zap->patronymic, patronymic, 30);

    currentBlock->zap_block[id] = *zap;

    saveChanges();
}

void DBMS::deleteZap(int id_zachet) {
    int id = getZapIdWithIdZachet(id_zachet);

    if (id == -1){
        std::cout << "Error - no student with this id_zachet" << std::endl;
        return;
    }
    currentBlock->zap_block[id].free = true;

    saveChanges();
}

std::string DBMS::getAllZapsInStr() {
    std::string answer;
    if (controlBlock->blocksAmount != 0)
        loadBlock(0);

    for (int i = 0; i < controlBlock->blocksAmount; ++i) {
        answer+= "[Block " + std::to_string(i);

        if (currentBlock->full){
            answer += ":FULL]\n\n";
        } else {
            answer += ":FREE]\n\n";
        }

        for (int j = 0; j < BLOCK_LENGTH; ++j) {

            answer+="{Zap " + std::to_string(j);

            if (currentBlock->zap_block[j].free)
                answer+=":FREE}\n";
            else {
                answer += ":FULL}\n";

                answer += "id_zachet: " +
                          std::to_string(currentBlock->zap_block[j].id_zachet) +
                          "\n";
                answer += "id_gr: " +
                          std::to_string(currentBlock->zap_block[j].id_gr) +
                          "\n";
                answer += "name: " +
                          std::string(currentBlock->zap_block[j].surname) +
                          " " + std::string(currentBlock->zap_block[j].name) +
                          " " + std::string(currentBlock->zap_block[j].patronymic);
            }
            answer += "\n\n";

        }

        answer+="\n\n";
        loadNextBlock();
    }

    return answer;
}

void DBMS::saveCurrentBlockInMem(Block *block) {
    if (!block->full)
        for (int i = 0; i < BLOCK_LENGTH; ++i) {
            if (block->zap_block[i].free) {
                memset(block->zap_block[i].patronymic, '\0', sizeof(char) * 30);
                memset(block->zap_block[i].name, '\0', sizeof(char) * 20);
                memset(block->zap_block[i].surname, '\0', sizeof(char) * 30);
                block->zap_block[i].id_gr = 0;
                block->zap_block[i].id_zachet = 0;
            }
        }

    long int offset = sizeof(ControlBlock) + sizeof(Block)*block->id;
    fseek(fp, offset, SEEK_SET);
    fwrite(block, sizeof(Block), 1, fp);
}

bool DBMS::blockIsFull(Block* block) {
    for (int i = 0; i < BLOCK_LENGTH; ++i) {
        if (block->zap_block[i].free)
            return false;
    }
    block->full = true;
    saveChanges();
    return true;
}

void DBMS::addStudent() {
    //todo: check id_zachet if db contains it already
    int id_zachet, id_gr;
    char surname[30], name[20], patronymic[30];

    std::cout << "Enter id_zachet\n>";
    std::cin >> id_zachet;
    if (getZapIdWithIdZachet(id_zachet) != -1){
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
    zap->free = false;
    zap->id_zachet = id_zachet;
    zap->id_gr = id_gr;
    strncpy(zap->surname, surname, 30);
    strncpy(zap->name, name, 20);
    strncpy(zap->patronymic, patronymic, 30);

    addZap(zap);
}

bool DBMS::isControlBlockCorrect() {

    return  strcmp(controlBlock->checksum, CHECK_SUM) == 0 &&
            controlBlock->sizeOfBlock == sizeof(Block) &&
            controlBlock->blockLengthInZaps == this->BLOCK_LENGTH;
}

Block *DBMS::loadNextBlock() {
    if (currentBlock != nullptr
    && currentBlock->id + 1 != controlBlock->blocksAmount){
        saveChanges();

        size_t offset =
                sizeof(ControlBlock) + (currentBlock->id+1) * sizeof(Block);

        fseek(fp, offset, SEEK_SET);

        fread(currentBlock, sizeof(Block), 1, fp);
    } else if (currentBlock == nullptr && controlBlock->blocksAmount != 0) {
            size_t offset =
                sizeof(ControlBlock);

            fseek(fp, offset, SEEK_SET);
            currentBlock = new Block;
            fread(currentBlock, sizeof(Block), 1, fp);
        }


}

void DBMS::saveControlBlockInMem() {
    fseek(fp, 0, SEEK_SET);
    fwrite(controlBlock, sizeof(ControlBlock), 1, fp);
}

void DBMS::saveChanges() {
    saveControlBlockInMem();
    if (controlBlock->blocksAmount != 0) {
        saveCurrentBlockInMem(currentBlock);
    }
}

void DBMS::loadBlock(int blockId) {
    size_t offset = sizeof(ControlBlock) + blockId*sizeof(Block);
    fseek(fp, offset, SEEK_SET);
    fread(currentBlock, sizeof(Block), 1, fp);
}

int DBMS::getZapIdWithIdZachet(int id_zachet) {
    loadBlock(0);
    for (int i = 0; i < controlBlock->blocksAmount; ++i) {
        for (int j = 0; j < BLOCK_LENGTH; ++j) {
            if (currentBlock->zap_block[j].id_zachet == id_zachet)
                return j;
        }
        loadNextBlock();
    }
    return -1;
}












