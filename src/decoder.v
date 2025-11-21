`define I_OP		7'b0010011
`define I_JALR 	7'b1100111
`define I_LOAD		7'b0000011
`define U_LUI		7'b0110111
`define U_AUIPC	7'b0010111
`define J			7'b1101111
`define S			7'b0100011
`define B			7'b1100011
`define R			7'b0110011

module decoder(
	input		wire	[31:0]	instr,
	output	wire	[6:0]		funct7,
	output	reg	[4:0]		rs2, // Cambiado a 'reg' para poder asignarlo en el always block
	output	wire	[4:0]		rs1,
	output	wire	[2:0]		funct3,
	output	wire	[4:0]		rd,
	output	wire	[6:0]		opcode,
	output	reg				reg_flag,
	output	reg	[31:0]	imm_ext
);

assign funct7 = instr[31:25];
assign rs1 = instr[19:15];
assign funct3 = instr[14:12];
assign rd = instr[11:7];
assign opcode = instr[6:0];

always @(*) begin

	reg_flag <= 0;
	// Por defecto, asumimos que rs2 no es un registro fuente.
	// Esto es crucial para instrucciones I, J, U, S y B, donde rs2 es parte del inmediato o no existe.
	rs2 <= 5'b0; // Asigna rs2 al registro x0 (0) para evitar hazards de pipeline.

	case(opcode)
	
		`I_OP: begin
			case(funct3)
				3'b010, /*SLTI*/ 3'b011, /*SLTIU*/ 3'b111, /*ANDI*/ 3'b110, /*ORI*/ 3'b100, /*XORI*/ 3'b000: begin
					imm_ext = {{20{instr[31]}}, instr[31:20]};
					case(instr[31:7])
						25'b0: ;				//NOP
						default: ;			//ADDI, etc.
					endcase
				end
				
				3'b001, /*SLLI*/ 3'b101: begin
					imm_ext = {27'b0, instr[24:20]};
					case(instr[30])
						1'b0:	;				//SRLI
						1'b1: ;				//SRAI
					endcase
				end
			endcase
		end
			
		`I_JALR: begin						//JALR
			imm_ext = {{20{instr[31]}}, instr[31:20]};
		end
		
		`I_LOAD: begin
			case(funct3)
				3'b010, /*LW*/ 3'b001, /*LH*/	3'b101, /*LHU*/ 3'b000,	/*LB*/ 3'b100: begin //LBU
					imm_ext = {{20{instr[31]}}, instr[31:20]};
					reg_flag <= 1;
				end
			endcase
        end
		
		`U_LUI, /*LUI*/	`U_AUIPC: begin	//AUIPC
			imm_ext = {instr[31:12], 12'b0};
		end
		
		`J: begin								//JAL
			imm_ext = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
		end
		
		`S: begin
			// Las instrucciones S sí usan rs2 como un registro fuente
			rs2 <= instr[24:20];
			
			case(funct3)
				3'b010, /*SW*/	3'b001, /*SH*/ 3'b000: begin //SB
					imm_ext = {{20{instr[31]}}, instr[31:25], instr[11:7]};
					reg_flag <= 1;
				end
			endcase
		end
		
		`B: begin
			// Las instrucciones B sí usan rs2 como un registro fuente
			rs2 <= instr[24:20];
			
			case(funct3)
				3'b000, /*BEQ*/ 3'b001,	/*BNE*/ 3'b100, /*BLT*/ 3'b101, /*BGE*/ 3'b110,	/*BLTU*/	3'b111: begin //BGEU
					imm_ext = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
				end
			endcase
        end
		
		`R: begin
			// Las instrucciones R sí usan rs2 como un registro fuente
			rs2 <= instr[24:20]; 
			
			case(funct3)
				3'b000: begin
					case(instr[30])
						1'b0: ;				//ADD
						1'b1: ;				//SUB
					endcase
				end
					
				3'b010: ;					//SLT
				3'b011: ;					//LTU
				3'b001: ;					//SLL
				3'b101: begin
					case(instr[30])
						1'b0: ;				//SRL
						1'b1: ;				//SRA
					endcase
				end
			endcase	
		end
		
		default: begin
			// Instrucción desconocida, por seguridad
			imm_ext = 32'b0;
			rs2 <= 5'b0;
		end
	endcase
end

endmodule