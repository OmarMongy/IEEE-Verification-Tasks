module AdvancedCounter (
    input wire clk,
    input wire rst,
    input wire en_inc,
    input wire en_dec,
    input wire load,
    input wire hold,
    input wire [3:0] load_value,
    output reg [3:0] count
);

always @(posedge clk) begin
    if (rst == 1'b1) begin
        count <= 4'd0; // Reset condition
    end else if (load == 1'b1) begin
        count <= load_value; // Load new value
    end else if (hold == 1'b1) begin
        count <= count; // Hold current value
    end else begin
        if (en_inc == 1'b1) begin
            count <= count + 1; // Increment condition
        end else if (en_dec == 1'b1) begin
            count <= count - 1; // Decrement condition
        end
    end
end

endmodule
