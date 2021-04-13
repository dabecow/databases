#ifndef LAB_2_ZAP_H
#define LAB_2_ZAP_H


struct Zap{
    bool filled;
    int id_zachet;
    int id_gr;
    char surname[20];
    char name[20];
    char patronymic[30];
};

struct Block{
    bool filled;
    Zap Zap_block[5];
    int bucketNumber;
    size_t offset;
    size_t NextBlockOffset;
};

#endif //LAB_2_ZAP_H
