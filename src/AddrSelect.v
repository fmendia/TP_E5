module AddrSelect (
    input  wire [1:0]  loadstore,     // 00: nada, 01: load, 10: store
    input  wire [2:0]  funct3,        // tipo de acceso (SB, SH, SW)
    input  wire [31:0] rs1,
    input  wire [31:0] imm,
    input  wire [31:0] rs2, // dato original (sin alinear)
    output wire [9:0]  mem_address,   // dirección por palabra
    output reg  [3:0]  byte_enable,   // bytes activos
    output reg  [31:0] store_data_aligned, // dato alineado al byteenable
	 output wire        mem_write
);

    wire [31:0] addr_full;
    wire [1:0]  addr_lsb;

    // Dirección completa (byte addressing)
    assign addr_full = rs1 + imm;
    assign addr_lsb  = addr_full[1:0];

    // Dirección de palabra (quita los 2 bits menos significativos)
    assign mem_address = (loadstore != 2'b00) ?
                         ((addr_full[11:2] < 1024) ? addr_full[11:2] : 10'b0) :
                         10'b0;
								 
	 assign mem_write = (loadstore != 2'b10) ? 0 : 1;

    // Lógica principal
    always @(*) begin
        byte_enable        = 4'b0000;
        store_data_aligned = 32'b0;

        if (loadstore == 2'b10) begin // STORE
            case (funct3)
                3'b000: begin // SB - Store byte
                    case (addr_lsb)
                        2'b00: begin
                            byte_enable        = 4'b0001;
                            store_data_aligned = {24'b0, rs2[7:0]};
                        end
                        2'b01: begin
                            byte_enable        = 4'b0010;
                            store_data_aligned = {16'b0, rs2[7:0], 8'b0};
                        end
                        2'b10: begin
                            byte_enable        = 4'b0100;
                            store_data_aligned = {8'b0, rs2[7:0], 16'b0};
                        end
                        2'b11: begin
                            byte_enable        = 4'b1000;
                            store_data_aligned = {rs2[7:0], 24'b0};
                        end
                    endcase
                end

                3'b001: begin // SH - Store halfword
                    byte_enable        = 4'b0011;
                    store_data_aligned = {16'b0, rs2[15:0]};
                end

                3'b010: begin // SW - Store word
                    byte_enable        = 4'b1111;
                    store_data_aligned = rs2;
                end

                default: begin
                    byte_enable        = 4'b0000;
                    store_data_aligned = 32'b0;
                end
            endcase
        end
    end

endmodule
