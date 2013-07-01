module mecab_c;


struct mecab_t;

struct mecab_path_t {
    mecab_node_t*  rnode;
    mecab_path_t*  rnext;
    mecab_node_t*  lnode;
    mecab_path_t*  lnext;
    int            cost;
    float          prob;
}

struct mecab_node_t {
    mecab_node_t*  prev;
    mecab_node_t*  next;
    mecab_node_t*  enext;
    mecab_node_t*  bnext;
    mecab_path_t*  rpath;
    mecab_path_t*  lpath;
    const(char)*   surface;
    const(char)*   feature;
    uint           id;
    ushort         length;
    ushort         rlength;
    ushort         rcAttr;
    ushort         lcAttr;
    ushort         posid;
    ubyte          char_type;
    ubyte          stat;
    ubyte          isbest;
    float          alpha;
    float          beta;
    float          prob;
    short          wcost;
    long           cost;
}

enum {
    MECAB_NOR_NODE = 0,
    MECAB_UNK_NODE = 1,
    MECAB_BOS_NODE = 2,
    MECAB_EOS_NODE = 3,
    MECAB_EON_NODE = 4
};

extern(C) {
    mecab_t* mecab_new(int argc, char** argv);
    void mecab_destroy(mecab_t* mecab);
    mecab_node_t* mecab_sparse_tonode(mecab_t* mecab, const(char)* str);
    mecab_node_t* mecab_sparse_tonode2(mecab_t* mecab, const(char)* str, size_t len);
}