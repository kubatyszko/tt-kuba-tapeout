/*
This file provides the mapping from the Wokwi modules to Verilog HDL.

It's only needed for Wokwi designs.
*/

`define default_netname none

(* keep_hierarchy*)
module demux_4to16 (D, S, Y);
    input  D;
    input  [3:0] S;
    output [15:0] Y;

    wire [3:0] S_n;
    wire D0, D1;
    wire [3:0] U, L;

    // Stage 0: 4x NOT
    not u_inv0 (S_n[0], S[0]);
    not u_inv1 (S_n[1], S[1]);
    not u_inv2 (S_n[2], S[2]);
    not u_inv3 (S_n[3], S[3]);

    // Stage 1: Upper 1-to-2 DEMUX (2x AND2)
    and u_d0 (D0, D, S_n[3]);
    and u_d1 (D1, D, S[3]);

    // Stage 1b: Lower 2-to-4 Decoder (4x AND2)
    and u_l0 (L[0], S_n[1], S_n[0]);
    and u_l1 (L[1], S_n[1], S[0]);
    and u_l2 (L[2], S[1],   S_n[0]);
    and u_l3 (L[3], S[1],   S[0]);

    // Stage 2: Upper 2-to-4 DEMUX (4x AND2)
    and u_u0 (U[0], D0, S_n[2]);
    and u_u1 (U[1], D0, S[2]);
    and u_u2 (U[2], D1, S_n[2]);
    and u_u3 (U[3], D1, S[2]);

    // Stage 3: Output Matrix (16x AND2)
    and u_y0  (Y[0],  U[0], L[0]);
    and u_y1  (Y[1],  U[0], L[1]);
    and u_y2  (Y[2],  U[0], L[2]);
    and u_y3  (Y[3],  U[0], L[3]);
    and u_y4  (Y[4],  U[1], L[0]);
    and u_y5  (Y[5],  U[1], L[1]);
    and u_y6  (Y[6],  U[1], L[2]);
    and u_y7  (Y[7],  U[1], L[3]);
    and u_y8  (Y[8],  U[2], L[0]);
    and u_y9  (Y[9],  U[2], L[1]);
    and u_y10 (Y[10], U[2], L[2]);
    and u_y11 (Y[11], U[2], L[3]);
    and u_y12 (Y[12], U[3], L[0]);
    and u_y13 (Y[13], U[3], L[1]);
    and u_y14 (Y[14], U[3], L[2]);
    and u_y15 (Y[15], U[3], L[3]);
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
