#ifndef LAB_2_CONTROLBLOCK_H
#define LAB_2_CONTROLBLOCK_H

struct ControlBlock {
    char Relation_scheme[255];
    size_t hashTableOffsets[10];
};
#endif //LAB_2_CONTROLBLOCK_H
