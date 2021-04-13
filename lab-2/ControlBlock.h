#ifndef LAB_2_CONTROLBLOCK_H
#define LAB_2_CONTROLBLOCK_H

struct ControlBlock {
    char Relation_scheme[255];
    int hashTableFirstBlockOffsets[5];
    int hashTableLastBlockOffsets[5];
};
#endif //LAB_2_CONTROLBLOCK_H
