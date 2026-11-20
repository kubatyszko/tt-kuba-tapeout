/*
This file provides the mapping from the Wokwi modules to Verilog HDL.

It's only needed for Wokwi designs.
*/

`define default_netname none

(* keep_hierarchy*)

module demux_4to16 (
    input  wire        D,
    input  wire [3:0]  S,
    output wire [15:0] Y
);
    wire [3:0] S_n;
    wire       D0, D1;
    wire [3:0] U, L;

    // Stage 0: 4x NOT
    not (S_n[0], S[0]);
    not (S_n[1], S[1]);
    not (S_n[2], S[2]);
    not (S_n[3], S[3]);

    // Stage 1: Upper 1-to-2 DEMUX (2x AND2)
    and (D0, D, S_n[3]);
    and (D1, D, S[3]);

    // Stage 1b: Lower 2-to-4 Decoder (4x AND2)
    and (L[0], S_n[1], S_n[0]);
    and (L[1], S_n[1], S[0]);
    and (L[2], S[1],   S_n[0]);
    and (L[3], S[1],   S[0]);

    // Stage 2: Upper 2-to-4 DEMUX (4x AND2)
    and (U[0], D0, S_n[2]);
    and (U[1], D0, S[2]);
    and (U[2], D1, S_n[2]);
    and (U[3], D1, S[2]);

    // Stage 3: Output Matrix (16x AND2)
    genvar j, k;
    generate
        for (j = 0; j < 4; j = j + 1) begin : gen_u
            for (k = 0; k < 4; k = k + 1) begin : gen_l
                and (Y[4*j + k], U[j], L[k]);
            end
        end
    endgenerate
endmodule
(* keep_hierarchy *)
module buffer_cell (
    input wire in,
    output wire out
    );
    assign out = in;
endmodule

(* keep_hierarchy *)
module and_cell (
    input wire a,
    input wire b,
    output wire out
    );

    assign out = a & b;
endmodule

(* keep_hierarchy *)
module or_cell (
    input wire a,
    input wire b,
    output wire out
    );

    assign out = a | b;
endmodule

(* keep_hierarchy *)
module xor_cell (
    input wire a,
    input wire b,
    output wire out
    );

    assign out = a ^ b;
endmodule

(* keep_hierarchy *)
module nand_cell (
    input wire a,
    input wire b,
    output wire out
    );

    assign out = !(a&b);
endmodule

(* keep_hierarchy *)
module nor_cell (
    input wire a,
    input wire b,
    output wire out
    );

    assign out = !(a | b);
endmodule

(* keep_hierarchy *)
module xnor_cell (
    input wire a,
    input wire b,
    output wire out
    );

    assign out = !(a ^ b);
endmodule

(* keep_hierarchy *)
module not_cell (
    input wire in,
    output wire out
    );

    assign out = !in;
endmodule

(* keep_hierarchy *)
module mux_cell (
    input wire a,
    input wire b,
    input wire sel,
    output wire out
    );

    assign out = sel ? b : a;
endmodule

(* keep_hierarchy *)
module dff_cell (
    input wire clk,
    input wire d,
    output reg q,
    output wire notq
    );

    assign notq = !q;
    always @(posedge clk)
        q <= d;

endmodule

(* keep_hierarchy *)
module dffr_cell (
    input wire clk,
    input wire d,
    input wire r,
    output reg q,
    output wire notq
    );

    assign notq = !q;

    always @(posedge clk or posedge r) begin
        if (r)
            q <= 0;
        else
            q <= d;
    end
endmodule

(* keep_hierarchy *)
module dffsr_cell (
    input wire clk,
    input wire d,
    input wire s,
    input wire r,
    output reg q,
    output wire notq
    );

    assign notq = !q;

    always @(posedge clk or posedge s or posedge r) begin
        if (r)
            q <= 0;
        else if (s)
            q <= 1;
        else
            q <= d;
    end
endmodule
