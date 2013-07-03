module mecab;

import std.algorithm;
import std.array;
import std.string;

import mecab_c;


alias MECAB_NOR_NODE NOR_NODE;
alias MECAB_UNK_NODE UNK_NODE;
alias MECAB_BOS_NODE BOS_NODE;
alias MECAB_EOS_NODE EOS_NODE;
alias MECAB_EON_NODE EON_NODE;

struct Node {
    private mecab_node_t* node_;

    @property string surface() pure { return node_.surface[0..node_.length].idup; }
    @property string[] feature() {
        uint n = 0;
        while (node_.feature[n] != '\0') ++n;
        return splitter(node_.feature[0..n].idup, ',').array;
    }
    @property uint   id()        pure { return node_.id; }
    @property ushort length()    pure { return node_.length; }
    @property ushort rlength()   pure { return node_.rlength; }
    @property ushort rcAttr()    pure { return node_.rcAttr; }
    @property ushort lcAttr()    pure { return node_.lcAttr; }
    @property ushort posid()     pure { return node_.posid; }
    @property ubyte  char_type() pure { return node_.char_type; }
    @property ubyte  stat()      pure { return node_.stat; }
    @property ubyte  isbest()    pure { return node_.isbest; }
    @property float  alpha()     pure { return node_.alpha; }
    @property float  beta()      pure { return node_.beta; }
    @property float  prob()      pure { return node_.prob; }
    @property short  wcost()     pure { return node_.wcost; }
    @property long   cost()      pure { return node_.cost; }
}

struct ParsedNodes {
    private mecab_t* mecab_;
    private mecab_node_t* node_;
    private const(char)* str_;

    this(string str) {
        str_ = str.toStringz;
        mecab_ = mecab_new(0, null);
        node_ = mecab_sparse_tonode(mecab_, str_);
    }

    ~this() {
        mecab_destroy(mecab_);
    }

    @property bool empty() const { return !node_; }
    Range opSlice() { return Range(node_); }
    @property Node front() { return Node(node_); }

    struct Range {
        mecab_node_t* node_;
        this(mecab_node_t* node) {
            node_ = node;
        }
        @property bool empty() const { return !node_; }
        @property Node front() { return Node(node_); }
        void popFront() { node_ = node_.next; }
        @property Range save() { return this; }
    }
}
