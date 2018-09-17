int global_val = 1;
static int static_global_val = 2;
int main()
{
    static int static_val = 3;
    __block int auto_val = 4;
    
    void (^blk)(void) = ^ {
        global_val *= 4;
        static_global_val *= 5;
        static_val *= 6;
        auto_val *= 7;
    };
    
    void (^blk_1)(void) = ^ {
        global_val *= 8;
        static_global_val *= 9;
        static_val *= 10;
        auto_val *= 11;
    };
    return 0;
}
