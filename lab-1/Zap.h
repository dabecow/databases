#ifndef LAB_1_ZAP_H
#define LAB_1_ZAP_H

struct Zap {
    bool free;
    int id_zachet;
    int id_gr;
    char surname[30];
    char name[20];
    char patronymic[30];

};

struct Block {
    int id;
    bool full;
    Zap zap_block[5];
};


#endif //LAB_1_ZAP_H
