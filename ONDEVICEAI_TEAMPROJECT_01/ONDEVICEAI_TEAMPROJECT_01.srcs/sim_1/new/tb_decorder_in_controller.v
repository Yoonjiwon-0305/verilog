`timescale 1ns / 1ps

module tb_InputControl();

    reg        iClk;
    reg        iRst;
    reg  [4:0] iBtnPulseFpga;
    reg  [2:0] iSwLevelFpga;
    reg  [4:0] iBtnPulsePc;
    reg        iSw1PulsePc;
    reg        iSw2PulsePc;
    reg        iSw3PulsePc;
    reg        iReqFndPc;
    reg        iReqStatePc;
    reg        iReqStopwatchPc;
    reg        iReqWatchPc;
    reg        iReqHcsr04Pc;
    reg        iReqDht11Pc;

    wire [1:0] oMode;
    wire       oModeLock;
    wire       oCmdValid;
    wire [4:0] oCmdCode;

    InputControl uut (
        .iClk(iClk),
        .iRst(iRst),
        .iBtnPulseFpga(iBtnPulseFpga),
        .iSwLevelFpga(iSwLevelFpga),
        .iBtnPulsePc(iBtnPulsePc),
        .iSw1PulsePc(iSw1PulsePc),
        .iSw2PulsePc(iSw2PulsePc),
        .iSw3PulsePc(iSw3PulsePc),
        .iReqFndPc(iReqFndPc),
        .iReqStatePc(iReqStatePc),
        .iReqStopwatchPc(iReqStopwatchPc),
        .iReqWatchPc(iReqWatchPc),
        .iReqHcsr04Pc(iReqHcsr04Pc),
        .iReqDht11Pc(iReqDht11Pc),
        .oMode(oMode),
        .oModeLock(oModeLock),
        .oCmdValid(oCmdValid),
        .oCmdCode(oCmdCode)
    );

    always #5 iClk = ~iClk;

    initial begin
        iClk = 0;
        iRst = 1;
        iBtnPulseFpga = 0;
        iSwLevelFpga = 0;
        iBtnPulsePc = 0;
        iSw1PulsePc = 0;
        iSw2PulsePc = 0;
        iSw3PulsePc = 0;
        iReqFndPc = 0;
        iReqStatePc = 0;
        iReqStopwatchPc = 0;
        iReqWatchPc = 0;
        iReqHcsr04Pc = 0;
        iReqDht11Pc = 0;

        #20 iRst = 0;

        #20;
        iBtnPulseFpga[1] = 1; 
        #10;
        iBtnPulseFpga[1] = 0;

        #30;
        iBtnPulseFpga[3] = 1; 
        #10;
        iBtnPulseFpga[3] = 0;

        #30;
        iSw1PulsePc = 1; 
        #10;
        iSw1PulsePc = 0;

        #20;
        iBtnPulsePc[1] = 1; 
        #10;
        iBtnPulsePc[1] = 0;

        #30;
        iBtnPulseFpga[4] = 1; 
        #10;
        iBtnPulseFpga[4] = 0;

        #30;
        iBtnPulsePc[1] = 1; 
        #10;
        iBtnPulsePc[1] = 0;

        #20;
        iSw1PulsePc = 1; 
        #10;
        iSw1PulsePc = 0;

        #100 $finish;
    end

endmodule