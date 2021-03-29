//
// Created by Andrew on 03.03.2021.
//

#ifndef LAB_1_CONTROLBLOCK_H
#define LAB_1_CONTROLBLOCK_H

#include "Zap.h"



struct ControlBlock{
    char checksum[10];
    int sizeOfBlock;
    int blockLengthInZaps;
    int blocksAmount;
};

#endif //LAB_1_CONTROLBLOCK_H
