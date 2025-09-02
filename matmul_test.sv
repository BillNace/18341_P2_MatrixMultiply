`timescale 1ns / 1ps

module matmul_test;

    logic CLOCK_100;
    logic [15:0] SW;
    logic [3:0] BTN;
    logic [7:0] D0_SEG, D1_SEG;
    logic [3:0] D0_AN, D1_AN;

    ChipInterface DUT (
    .CLOCK_100,
    .SW,
    .BTN,
    .D0_SEG,
    .D1_SEG,
    .D0_AN,
    .D1_AN
    );

    initial begin
        CLOCK_100 = 0;
        forever #5 CLOCK_100 = ~CLOCK_100;
    end

    initial begin
        BTN[3:0] = 4'b1111;
        SW[15:0] = 0;
        #100;
        BTN[3:0] = 0;
        #1000000000;
        $finish;
    end

endmodule
