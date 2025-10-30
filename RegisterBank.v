module RegisterBank (
    input wire clk,             // Señal de reloj para la escritura
    
    // -----------------------------------------------------------------
    // Puertos de Lectura Combinacional (Read Ports)
    // -----------------------------------------------------------------
    input wire [4:0] rs1_addr,  // Dirección del registro fuente 1
    input wire [4:0] rs2_addr,  // Dirección del registro fuente 2
    output wire [31:0] rs1_data, // Dato leído de rs1
    output wire [31:0] rs2_data, // Dato leído de rs2
    
    // -----------------------------------------------------------------
    // Puertos de Escritura Secuencial (Write Port)
    // -----------------------------------------------------------------
    input wire [4:0] rd_addr,   // Dirección del registro destino (Write Back)
    input wire write_ena,       // Habilitación de escritura
    input wire [31:0] rd_data    // Dato a escribir
);

    // Memoria interna: Arreglo de 32 registros, debe ser 'reg'
    reg [31:0] registers [0:31]; 
    
    // ----------------------------------------------------------------
    // LÓGICA DE LECTURA (COMBINACIONAL)
    // ----------------------------------------------------------------
    // Usa 'assign' para la lógica instantánea.
    assign rs1_data = (rs1_addr == 5'h0) ? 32'h0 : registers[rs1_addr];
    assign rs2_data = (rs2_addr == 5'h0) ? 32'h0 : registers[rs2_addr];
    
    
    // ----------------------------------------------------------------
    // LÓGICA DE ESCRITURA (SECUENCIAL - Write Back)
    // ----------------------------------------------------------------
    
    // Usa 'always @(posedge clk)' para modelar Flip-Flops.
    always @(posedge clk) begin
        // 1. Control de Habilitación
        if (write_ena) begin
            // 2. Control del Registro Cero ($x0$): Ignorar escritura en dirección 0
            //if (rd_addr != 5'h0) begin //Probar borrar esta condición
                // 3. Asignación Secuencial
                registers[rd_addr] <= rd_data; // Usamos '<=' (no bloqueante) para FFs
            //end
        end
    end

endmodule