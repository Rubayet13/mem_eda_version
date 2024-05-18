typedef enum {RESET, IDLE, WRITE, READ} OPERATION;

parameter addrWidth = 16;
parameter dataWidth = 32;

typedef bit [addrWidth -1:0] ADDR_VAL;
typedef bit [dataWidth -1:0] DATA_VAL;


