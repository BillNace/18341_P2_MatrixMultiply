// Required in every 18-240 file, but commented out to prevent synthesis issues
// `default_nettype none

// Starter code for Project 2.  See README.md for details

module ChipInterface
  (input  logic         CLOCK_100, // 100 MHZ Clock
   input  logic [15:0]  SW,
   input  logic [3:0]   BTN,
   output logic [7:0]   D0_SEG, D1_SEG,
   output logic [3:0]   D0_AN, D1_AN);

endmodule : ChipInterface
