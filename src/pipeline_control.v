//====================================================================
//  Módulo: pipeline_control
//  Autor: Felipe + GPT-5
//
//  Descripción:
//  Control central del pipeline del procesador ERV25.
//  Detecta hazards de datos y control entre las etapas del pipeline y
//  genera las señales de enable/flush correspondientes.
//
//  Topología del pipeline:
//      Stage1 → Fetch (IF)
//      Stage2 → Decode (ID)
//      Stage3 → Register Read / Operand Prepare (RR)
//      Stage4 → Execute / ALU / MemAddr (EX)
//      Stage5 → WriteBack (WB)
//
//  Entradas (por etapa):
//      - Decode:    rs1_D, rs2_D, rd_D, reg_flag_D
//      - RegRead:   rd_R,  reg_flag_R
//      - Execute:   rd_E,  reg_flag_E, mem_read_E, branch_E
//      - WriteBack: rd_W,  reg_flag_W
//
//  Salidas:
//      - enable_IF, enable_ID, enable_RR, enable_EX, enable_WB
//      - flush_IF, flush_ID, flush_EX
//====================================================================

module pipeline_control (
    // Señales desde Decode (Stage2)
    input  wire [4:0] rs1_D,
    input  wire [4:0] rs2_D,
    input  wire [4:0] rd_D,
    input  wire       reg_flag_D,

    // Señales desde Register Read (Stage3)
    input  wire [4:0] rd_R,
    input  wire       reg_flag_R,

    // Señales desde Execute (Stage4)
    input  wire [4:0] rd_E,
    input  wire       reg_flag_E,
    input  wire       branch_E,

    // Señales desde WriteBack (Stage5)
    input  wire [4:0] rd_W,
    input  wire       reg_flag_W,

    // Señales de control a los latches
    output reg  enable_F_D,
    output reg  enable_D_R,
    output reg  enable_R_E,
    output reg  enable_E_W,

    output reg  flush_F_D,
    output reg  flush_D_R,
    output reg  flush_R_E,
	 output reg  flush_E_W
);

    //--------------------------------------------------
    // Detección de hazards
    //--------------------------------------------------
    reg hazard_RAW1;
    reg hazard_RAW2;
    //reg hazard_RR;
    reg branch_taken;

    always @(*) begin
        // Defaults
        hazard_RAW1 = 1'b0;
        hazard_RAW2    = 1'b0;
        branch_taken   = 1'b0;

        // --- RAW1: En ALU hay rd y en R rsi tal que son iguales ---
        // No traer del banco de registros un valor del registro viejo
        if (reg_flag_E && ((rs1_D == rd_E && rs1_D != 5'd0) || (rs2_D == rd_E && rs2_D != 5'd0))) 
				begin
            hazard_RAW1 = 1'b1;
        end

        // --- RAW2: En R tengo un rsi y en W tengo mismo en rd ---
        // Estoy por actualizar el valor del registro, si lo levanta R, el valor es viejo
        else if (reg_flag_W && ((rs1_D == rd_W && rs1_D != 5'd0) || (rs2_D == rd_W && rs2_D != 5'd0))) begin
            hazard_RAW2 = 1'b1;
        end

        // --- Branch detectado en EX (Stage4) ---
        if (branch_E) begin
            branch_taken = 1'b1;
        end
    end

    //--------------------------------------------------
    // Control de enable/flush para los latches
    //--------------------------------------------------
    always @(*) begin
        // Valores por defecto (pipeline libre)
        enable_F_D  = 1'b1;
        enable_D_R  = 1'b1;
        enable_R_E  = 1'b1;
        enable_E_W  = 1'b1;
      
        flush_F_D   = 1'b0;
        flush_D_R   = 1'b0;
        flush_R_E   = 1'b0;
		  flush_E_W	 = 1'b0;

        //------------------------------------------------
        // 1️⃣ Branch tomado → limpiar IF y ID
        //------------------------------------------------
        if (branch_taken) begin
            flush_F_D  = 1'b1;//Lo que fetchee chau
            flush_D_R  = 1'b1;//lo que decodee chau
				//flush_R_E  = 1'b1;//lo que se va a ejecutqr en alu chau
            // Se permite avance para que IF tome nueva dirección
        end

        //------------------------------------------------
        // 2️⃣ Load-Use hazard → stall 1 ciclo
        //------------------------------------------------
        else if (hazard_RAW1) begin
            enable_F_D  = 1'b0; // no avanzar PC
            enable_D_R  = 1'b0; // mantener instrucción actual
            flush_R_E   = 1'b1; // burbuja en EX
        end

        //------------------------------------------------
        // 3️⃣ ALU-ALU hazard (sin forwarding)
        //------------------------------------------------
        else if (hazard_RAW2) begin
            enable_F_D  = 1'b0;
            enable_D_R  = 1'b0;
            flush_R_E   = 1'b1;//Burbuja a EX
        end

        //------------------------------------------------
        // 5️⃣ (Futuro) stalls globales por ready signals
        //------------------------------------------------
        // Ejemplo:
        // if (!alu_ready || !mem_ready) begin
        //     enable_IF  = 1'b0;
        //     enable_ID  = 1'b0;
        //     enable_RR  = 1'b0;
        //     enable_EX  = 1'b0;
        // end
    end

endmodule
