module register_2c_7b (
    input  wire        clk,
    input  wire [2:0]  in,
    output wire [2:0]  out
);

    // Registros internos para almacenar los datos
    reg [2:0] reg_stage1; // Primer flip-flop (atraso de 1 ciclo)
    reg [2:0] reg_stage2; // Segundo flip-flop (atraso de 2 ciclos)

    // Lógica secuencial (sensible al flanco positivo del reloj)
    always @(posedge clk) begin
        // En el primer flanco, 'in' se mueve a 'reg_stage1'
        reg_stage1 <= in;

        // En el mismo flanco, 'reg_stage1' (del ciclo anterior) se mueve a 'reg_stage2'
        reg_stage2 <= reg_stage1;
    end

    // Asignación de la salida
    // La salida es el valor del registro que ha pasado por los dos FFs
    assign out = reg_stage2;

endmodule