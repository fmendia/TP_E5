`define PC      2'b00
`define PC_4    2'b01
`define PC_ARB  2'b10

`define J			7'b1101111
`define I_JALR 	    7'b1100111
`define B			7'b1100011
`define I_LOAD		7'b0000011
`define S			7'b0100011

module Address_Builder(
	input	wire	[31:0]	pc,
	input	wire	[5:0]	CCR_flags,       //CCR: EQ|NE|LT|GE|LTU|GEU
	input	wire	[31:0]	rs1data,
	input	wire	[31:0]	rs2data,
	input	wire	[2:0]	funct3,
	input	wire	[6:0]	opcode,
	input	wire	[31:0]	imm_ext,
    output  reg     [1:0]   pc_sel,          //Comportamiento del pc para manejo de IFU
	output	reg	    [31:0]	pc_AB,		    //Modificación de PC vía IFU
	output	reg	    [31:0]	dataadd		    //Contenido a guardar en memoria
);

always @(*) begin
    //Lógica address builder
    case(opcode)
        `J: begin
            pc_sel = `PC_ARB;
            pc_AB = pc + imm_ext - 4;
        end

        `I_JALR: begin
            pc_sel = `PC_ARB;
            pc_AB = (rs1data + imm_ext) & 32'hFFFFFFFE;
        end

        `B: begin           //PARA LOS BRANCHES SUPONEMOS QUE LA ALU EVALÚA SI TOMAR O NO EL BRANCH
            case (funct3)
                3'b000: begin // BEQ
                    pc_sel = (CCR_flags[5]) ? `PC_ARB : `PC_4;
                end
                3'b001: begin // BNE
                    pc_sel = (CCR_flags[4]) ? `PC_ARB : `PC_4;
                end
                3'b100: begin // BLT
                    pc_sel = (CCR_flags[3]) ? `PC_ARB : `PC_4;
                end
                3'b101: begin // BGE
                    pc_sel = (CCR_flags[2]) ? `PC_ARB : `PC_4;
                end
                3'b110: begin // BLTU
                    pc_sel = (CCR_flags[1]) ? `PC_ARB : `PC_4;
                end
                3'b111: begin // BGEU
                    pc_sel = (CCR_flags[0]) ? `PC_ARB : `PC_4;
                end
                default: begin
                    pc_sel = `PC_4;
                end
            endcase

            if (pc_sel == `PC_ARB) begin
                pc_AB = pc + imm_ext;
            end
        end
        
        `I_LOAD: begin
            pc_sel = `PC_4;
            case(funct3)
                3'b010 /*LW*/:  begin
                // The LW instruction loads a 32-bit value from memory into rd
                    dataadd = rs1data + imm_ext;        //HACER FLAG DE LOAD O STORES (PARA COMUNICACIÓN CON REG BANK Y ESCRITURA O LECTURA DE MEMO?)
                end
                3'b001 /*LH*/:  begin
                //LH loads a 16-bit value from memory, then sign-extends to 32-bits before storing in rd
                    dataadd = rs1data + imm_ext;        //16B O 32? PROBLEMA DEL REG BANK?
                end
                3'b101 /*LHU*/: begin
                //LHU loads a 16-bit value from memory but then zero extends to 32-bits before storing in rd
                    dataadd = rs1data + imm_ext;        //!!!
                end
                3'b000 /*LB*/:  begin 
                //LB and LBU are defined analogously for 8-bit values
                    dataadd = rs1data + imm_ext;        //!!!
                end
                3'b100 /*LBU*/: begin
                //LB and LBU are defined analogously for 8-bit values
                    dataadd = rs1data + imm_ext;        //!!!  
                end

            endcase
        end

        `S: begin
            pc_sel = `PC_4;
            case(funct3)
                3'b010 /*SW*/: begin
                    dataadd = rs1data + imm_ext;    //EL REGBANK CARGA EL CONTENIDO DE DATAADD A RS2 (32B)
                end
                3'b001 /*SH*/: begin
                    dataadd = rs1data + imm_ext;    //EL REGBANK CARGA EL CONTENIDO DE DATAADD A RS2 (16B)
                end
                3'b000 /*SB*/: begin
                    dataadd = rs1data + imm_ext;    //EL REGBANK CARGA EL CONTENIDO DE DATAADD A RS2 (8B)
                end
            endcase
        end

        default: begin
            pc_sel = `PC_4;
        end

    endcase

end
endmodule