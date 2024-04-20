`default_nettype none
`timescale 1ns/1ns

// ALU
module alu (
    input wire clk,
    input wire reset,

    input reg [2:0] core_state,

    input reg [1:0] decoded_alu_arithmetic_mux,
    input reg decoded_alu_output_mux,

    input reg [7:0] rs,
    input reg [7:0] rt,
    output wire [7:0] alu_out
);
    localparam ADD = 2'b00,
        SUB = 2'b01,
        MUL = 2'b10,
        DIV = 2'b11;

    reg [7:0] alu_out_reg;
    assign alu_out = alu_out_reg;

    always @(posedge clk) begin 
        if (reset) begin 
            alu_out_reg <= 8'b0;
        end else begin
            alu_out_reg <= 8'b0;

            // Calculate alu_out when core_state = EXECUTE
            if (core_state == 3'b101) begin 
                if (decoded_alu_output_mux == 1) begin 
                    // Set values to compare with NZP register
                    alu_out_reg <= {5'b0, (rs - rt > 0), (rs - rt == 0), (rs - rt < 0)};
                end else begin 
                    case (decoded_alu_arithmetic_mux)
                        ADD: begin 
                            alu_out_reg <= rs + rt;
                        end
                        SUB: begin 
                            alu_out_reg <= rs - rt;
                        end
                        MUL: begin 
                            alu_out_reg <= rs * rt;
                        end
                        DIV: begin 
                            alu_out_reg <= rs / rt;
                        end
                    endcase
                end
            end
        end
    end
endmodule