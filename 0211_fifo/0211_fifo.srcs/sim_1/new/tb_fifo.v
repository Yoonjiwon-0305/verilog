`timescale 1ns / 1ps

module tb_fifo_1 ();

    reg clk, reset, push, pop;
    reg  [7:0] push_data;
    wire [7:0] pop_data;
    wire full, empty;

    reg rand_pop, rand_push;
    reg [7:0] rand_data;
    reg [7:0] compare_data[0:15];
    reg [3:0] push_cnt, pop_cnt;

    integer pass_cnt, fail_cnt;
    integer i;

    fifo dut (

        .clk  (clk),
        .reset(reset),
        .push (push),
        .pop  (pop),
        .wdata(push_data),
        .rdata(pop_data),
        .full (full),
        .empty(empty)

    );

    always #5 clk = ~clk;

    initial begin
        #0;
        clk       = 0;
        reset     = 1;
        push_data = 0;
        push      = 0;
        pop       = 0;
        i         = 0;
        rand_data = 0;
        rand_pop  = 0;
        rand_push = 0;
        push_cnt  = 0;
        pop_cnt   = 0;
        pass_cnt  = 0;
        fail_cnt  = 0;
        @(negedge clk);
        @(negedge clk);

        reset = 0;

        for (i = 0; i < 16; i = i + 1) begin

            push = 1;
            push_data = 8'h61 + i;
            @(negedge clk);
        end
        
        push = 0;
        
        for (i = 0; i < 16; i = i + 1) begin

            pop = 1;
            @(negedge clk);
        end
        pop = 0;

        //메모리에 1개 push 
        // 동시 push,pop

        push = 1;
        push_data = 8'haa;
        @(negedge clk);
        push = 0;
        @(negedge clk);

        for (i = 0; i < 16; i = i + 1) begin
            push = 1;
            pop = 1;
            push_data = i;
            @(negedge clk);
        end

        push = 0;
        pop  = 1;
        @(negedge clk);
        @(negedge clk);
        pop = 0;
        @(negedge clk);
        // 랜덤 test
        for (i = 0; i < 256; i = i + 1) begin
            rand_push = $random % 2; // 이렇게 하면 경우의 수 2개 ,% 다음의수는 몇가지의 랜덤수
            rand_pop = $random % 2;
            rand_data = $random % 256;  // 랜덤 데이터가 8비트이므로

            push = rand_push;
            push_data = rand_data;
            pop = rand_pop;

            #4;
            if (!full & push) begin
                compare_data[push_cnt] = rand_data;
                push_cnt = push_cnt + 1;
            end
            if (!empty & pop == 1) begin

                if (pop_data == compare_data[pop_cnt]) begin
                    $display("%t : pass, pop_data = %h, compare data = %h",
                             $time, pop_data, compare_data[pop_cnt]);
                    pass_cnt = pass_cnt + 1;
                end else begin
                    $display("%t : Fail!!!!!, pop_data = %h, compare data = %h",
                             $time, pop_data, compare_data[pop_cnt]);
                    fail_cnt = fail_cnt + 1;
                end
                pop_cnt = pop_cnt + 1;
            end
            //@(posedge clk);
            @(negedge clk);
        end
        $display("%t :pass count = %d , fail count = %d", $time, pass_cnt,
                 fail_cnt);
        repeat (5) @(negedge clk);
        $stop;

    end

endmodule
