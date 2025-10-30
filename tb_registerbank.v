module tb_registerbank;

    // Entradas del DUT (controladas por el TB)
    reg clk = 0;              // 1. Señal de Reloj (inicializada en 0)
    reg write_ena;            // 2. Habilitación de Escritura
    reg [4:0] rs1_addr;
    reg [4:0] rs2_addr;
    reg [4:0] rd_addr;        // 3. Dirección de Escritura
    reg [31:0] rd_data;        // 4. Dato a Escribir

    // Salidas del DUT (observadas por el TB)
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    // Instanciación del módulo RegisterBank (DUT: Device Under Test)
    // Se conectan todos los puertos, incluidos los nuevos
    RegisterBank DUT (
        .clk(clk),
        .write_ena(write_ena), 
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .rd_addr(rd_addr),
        .rd_data(rd_data)
    );

    // ----------------------------------------------------------------
    // Generador de Clock 
    // ----------------------------------------------------------------
    // Genera una señal de reloj con un período de 10 unidades de tiempo (5 alto, 5 bajo).
    always #5 clk = ~clk; 

    // ----------------------------------------------------------------
    // Bloque de Inicialización y Secuencia de Pruebas
    // ----------------------------------------------------------------
    initial begin
        $display("Inicio de la prueba de Escritura/Lectura Combinacional Secuencial...");
        
        // 1. Inicialización (Tiempo 0)
        write_ena = 0;
        rd_addr   = 5'd0; 
        rd_data   = 32'h0;
        rs1_addr  = 5'd0;
        rs2_addr  = 5'd0;
        
        #10; // Esperamos un ciclo completo del clock para estabilizar
        
        // ------------------------------------------------------------------
        // CASO 1: Escritura Secuencial Correcta (Escribir 12345678 en x1)
        // ------------------------------------------------------------------
        rd_addr   = 5'd1;           // Dirección de destino: x1
        rd_data   = 32'h12345678;   // Dato a escribir
        write_ena = 1;              // Habilitar escritura (Activa)
        
        #1; // Damos tiempo a las señales de entrada para estabilizar

        // -- CLAVE: PRUEBA DE COMBINACIONALIDAD VS SECUENCIALIDAD --
        rs1_addr = 5'd1; // Lectura de x1
        
        // Verificación 1: Antes del Flanco de Clock
        // Si la lectura es combinacional, rs1_data mostrará el valor ANTERIOR (0, si no se inicializó)
        $display("----------------------------------------");
        $display("TIEMPO 1: Lectura ANTES del flanco (x1)");
        $display("rs1_data: %h (Esperado 00000000 o valor anterior)", rs1_data);

        @(posedge clk); // ESPERAMOS el flanco de subida del clock (Aquí ocurre la escritura)
        write_ena = 0;  // Deshabilitar escritura inmediatamente después del flanco

        // Verificación 2: Después del Flanco de Clock
        #1;
        $display("TIEMPO 2: Lectura DESPUÉS del flanco (x1)");
        $display("rs1_data: %h (Esperado 12345678)", rs1_data); // ¡Debe ser el nuevo dato!

        // ------------------------------------------------------------------
        // CASO 2: Prueba de la Regla del Registro x0 (Ignorar escritura en x0)
        // ------------------------------------------------------------------
        rd_addr   = 5'd0;           // Dirección de destino: x0
        rd_data   = 32'hDEADBEEF;   // Dato que intentamos escribir
        write_ena = 1;              // Habilitar escritura
        
        @(posedge clk); // ESPERAMOS el flanco de subida
        write_ena = 0; 
        rs1_addr = 5'd0; // Lectura de x0
		  #1
        $display("----------------------------------------");
        $display("TIEMPO 3: Lectura de x0 después de intento de escritura");
        $display("rs1_addr: 5'd0 -> rs1_data: %h (Esperado 00000000)", rs1_data); // Debe seguir siendo cero
        $display("----------------------------------------");
		  
        $stop; // Detener la simulación
    end

endmodule