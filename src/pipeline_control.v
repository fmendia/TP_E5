module pipeline_control (
    // Señales desde Decode (Stage2 - D)
    input  wire [4:0] rs1_D,
    input  wire [4:0] rs2_D,
    input  wire [4:0] rd_D,
    input  wire       reg_flag_D,

    // Señales desde Register Read (Stage3 - R)
    input  wire [4:0] rs1_R,
    input  wire [4:0] rs2_R,
    input  wire [4:0] rd_R, // Registro destino en etapa R

    // Señales desde Execute (Stage4 - E)
    input  wire [4:0] rd_E, // Registro destino en etapa E
    input  wire       branch_E,

    // Señales desde WriteBack (Stage5 - W)
    input  wire [4:0] rd_W, // Registro destino en etapa W
    // Nota: Sería ideal tener input wire reg_flag_W aquí también para estar seguros

    // Señales de control a los latches
    output reg  enable_F_D,
    output reg  enable_D_R,
    output reg  enable_R_E,
    output reg  enable_E_W,

    output reg  flush_F_D,
    output reg  flush_D_R,
    output reg  flush_R_E,
    output reg  flush_E_W, // Generalmente esta etapa no se flushea, pero la dejo si la usas
    
    output reg  enable_IFU,
	 output reg  flush_IFU
);

    //--------------------------------------------------
    // Detección de hazards
    //--------------------------------------------------
    reg hazard_RAW1; // Conflicto con etapa R
    reg hazard_RAW2; // Conflicto con etapa E
    reg hazard_RAW3; // Conflicto con etapa W (NUEVO)
    reg branch_taken;
    
    // Señal interna para resumir si hay que frenar
    reg stall_needed; 

    always @(*) begin
        // 1. Inicialización de defaults
        hazard_RAW1  = 1'b0;
        hazard_RAW2  = 1'b0;
        hazard_RAW3  = 1'b0;
        branch_taken = 1'b0;
        stall_needed = 1'b0;

        // --- RAW1: Conflicto D vs R (Distancia 1) ---
        if ((rs1_D == rd_R && rs1_D != 5'd0) || (rs2_D == rd_R && rs2_D != 5'd0))
            hazard_RAW1 = 1'b1;

        // --- RAW2: Conflicto D vs E (Distancia 2) ---
        if ((rs1_D == rd_E && rs1_D != 5'd0) || (rs2_D == rd_E && rs2_D != 5'd0)) 
            hazard_RAW2 = 1'b1;
            
        // --- RAW3: Conflicto D vs W (Distancia 3) --- 
        // Si W todavía no escribió en el banco, D leería el valor viejo.
        if ((rs1_D == rd_W && rs1_D != 5'd0) || (rs2_D == rd_W && rs2_D != 5'd0)) 
            hazard_RAW3 = 1'b1;

        // --- Lógica de STALL Unificada ---
        // Si ocurre cualquiera de los 3 riesgos de datos, necesitamos STALL
        if (hazard_RAW1 || hazard_RAW2 || hazard_RAW3) begin
            stall_needed = 1'b1;
        end

        // --- Detección de Branch ---
        if (branch_E) begin
            branch_taken = 1'b1;
        end
    end

    //--------------------------------------------------
    // Control de enable/flush para los latches
    //--------------------------------------------------
    always @(*) begin
        // Valores por defecto (El pipeline fluye libremente)
        enable_F_D  = 1'b1;
        enable_D_R  = 1'b1;
        enable_R_E  = 1'b1;
        enable_E_W  = 1'b1;
        enable_IFU  = 1'b1;
       
        flush_F_D   = 1'b0;
        flush_D_R   = 1'b0;
        flush_R_E   = 1'b0;
        flush_E_W   = 1'b0;
		  flush_IFU   = 1'b0;

        //------------------------------------------------
        // Prioridad 1: Branch (Control Hazard)
        //------------------------------------------------
        // El salto mata todo lo que viene detrás, tenga stall o no.
        if (branch_taken) begin
            flush_F_D  = 1'b1; // Borrar instrucción en Fetch
            flush_D_R  = 1'b1; // Borrar instrucción en Decode
            flush_R_E  = 1'b1; // Borrar instrucción en RegRead (opcional según tu diseño)
				flush_IFU  = 1'b1; //Borrar instrucción en IFU
            // IFU sigue habilitada para saltar a la nueva dirección
        end

        //------------------------------------------------
        // Prioridad 2: Data Hazards (Stalls)
        //------------------------------------------------
        // Solo aplicamos stall si NO estamos tomando un branch 
        // (si hay branch, el flush limpia todo y el stall ya no importa)
        else if (stall_needed) begin
            // Congelamos el estado actual de Fetch y Decode
            enable_IFU  = 1'b0; // No buscar nueva instrucción
            enable_F_D  = 1'b0; // PC y Latch F/D se quedan quietos

            // Inyectamos una burbuja hacia adelante (hacia R)
            flush_D_R   = 1'b1; // La etapa R recibe un NOP en el siguiente ciclo
            
            // Las etapas R, E, W siguen avanzando normalmente para terminar su trabajo
        end
    end

endmodule