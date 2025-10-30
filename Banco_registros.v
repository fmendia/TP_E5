module RegisterBank (
    // -----------------------------------------------------------------
    // Puertos de Lectura Combinacional
    // -----------------------------------------------------------------
    input wire [4:0] rs1_addr,  // Dirección del registro fuente 1 (5 bits)
    input wire [4:0] rs2_addr,  // Dirección del registro fuente 2 (5 bits)
    output wire [31:0] rs1_data, // Dato leído de rs1 (32 bits)
    output wire [31:0] rs2_data  // Dato leído de rs2
);

    // Declaración de la memoria interna: El arreglo de registros.
    // Aunque la escritura está ausente, esta estructura define dónde están los datos.
    // Para la simulación, el Testbench es el que se encargará de "inicializar" estos valores.
    reg [31:0] registers [0:31]; 
    
    // ----------------------------------------------------------------
    // LÓGICA DE LECTURA (COMBINACIONAL)
    // ----------------------------------------------------------------
    
    // Lectura para rs1: Implementa la regla del registro x0.
    // Si la dirección es 0 (5'h0), la salida es 0. De lo contrario, lee del arreglo.
    assign rs1_data = (rs1_addr == 5'h0) ? 32'h0 : registers[rs1_addr];
    
    // Lectura para rs2: Mismo principio. El registro x0 (dirección 0) siempre devuelve 0[cite: 121].
    assign rs2_data = (rs2_addr == 5'h0) ? 32'h0 : registers[rs2_addr];
    
    // NOTA: La lógica de escritura secuencial (clk, write_enable, rd_addr, rd_data)
    // ha sido omitida para simplificar esta fase de prueba.

endmodule