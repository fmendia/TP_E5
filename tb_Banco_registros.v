module tb_registerbank;

    // 1. Declaración de las señales de conexión (se comportan como entradas/salidas)
    // Usamos 'reg' para las señales que queremos controlar (inputs del DUT)
    reg [4:0] rs1_addr;
    reg [4:0] rs2_addr;
    // Usamos 'wire' para las señales que queremos observar (outputs del DUT)
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    // 2. Instanciación del módulo RegisterBank (DUT: Device Under Test)
    // Asegúrate de que el nombre del módulo coincida con tu RegisterBank.v
    RegisterBank DUT (
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    // 3. Bloque de Inicialización y Secuencia de Pruebas
    initial begin
        $display("Inicio de la prueba de Lectura Combinacional...");
        
        // Inicialización de la memoria interna (Simulamos la escritura)
        // Como eliminamos la lógica CLK/Escritura, inicializamos los valores
        // directamente en el arreglo interno del DUT (solo funciona en simulación).
        // (Nota: La sintaxis 'DUT.registers' accede a la memoria interna del módulo instanciado)
        DUT.registers[5'd1] = 32'hDEADBEEF; // Valor de prueba para registro x1
        DUT.registers[5'd2] = 32'hBADC0DE0; // Valor de prueba para registro x2
        DUT.registers[5'd3] = 32'h12345678; // Valor de prueba para registro x3
        
        // ------------------------------------------------------------------
        // CASO 1: Lectura normal (x1 y x2) - Prueba de Combinacionalidad
        // ------------------------------------------------------------------
        
        // Asignamos las direcciones de lectura
        rs1_addr = 5'd1;  // Pedimos x1
        rs2_addr = 5'd2;  // Pedimos x2
        
        // CLAVE: Esperamos 1 unidad de tiempo (#1). Si la lectura es combinacional,
        // el dato debe aparecer en este instante, sin esperar un clock.
        #1; 
        $display("----------------------------------------");
        $display("TIEMPO 1: Lectura x1 y x2 (Combinacional)");
        $display("rs1_addr (x1): 5'd1 -> rs1_data: %h (Esperado DEADBEEF)", rs1_data);
        $display("rs2_addr (x2): 5'd2 -> rs2_data: %h (Esperado BADC0DE0)", rs2_data);
        
        // ------------------------------------------------------------------
        // CASO 2: Prueba de la regla del Registro x0 (Lectura de 0 constante)
        // ------------------------------------------------------------------
        
        // Asignamos la dirección 0 a rs1
        rs1_addr = 5'd0;  // Pedimos x0
        rs2_addr = 5'd3;  // Pedimos x3
        
        #1; // Verificamos instantáneamente el resultado
        $display("----------------------------------------");
        $display("TIEMPO 2: Lectura x0 y x3 (Regla x0)");
        $display("rs1_addr (x0): 5'd0 -> rs1_data: %h (Esperado 00000000)", rs1_data);
        $display("rs2_addr (x3): 5'd3 -> rs2_data: %h (Esperado 12345678)", rs2_data);

        // ------------------------------------------------------------------
        // CASO 3: Cambio Rápido de Dirección (x1 a x3)
        // ------------------------------------------------------------------
        
        rs1_addr = 5'd3;  // Cambiamos rs1 a x3
        rs2_addr = 5'd1;  // Cambiamos rs2 a x1
        
        #1; // Verificamos el cambio instantáneo
        $display("----------------------------------------");
        $display("TIEMPO 3: Cambio de x0 a x3 y x3 a x1");
        $display("rs1_addr (x3): 5'd3 -> rs1_data: %h (Esperado 12345678)", rs1_data);
        $display("rs2_addr (x1): 5'd1 -> rs2_data: %h (Esperado DEADBEEF)", rs2_data);
        $display("----------------------------------------");
        
        $stop; // Detener la simulación
    end

endmodule