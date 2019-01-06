module VGA(clk, rst, vga_hs, vga_vs, vga_r, vga_g, vga_b, floor);

input [4:0] floor;//remember floor
input clk, rst;
output vga_hs, vga_vs;
output [3:0] vga_r, vga_g, vga_b;

reg vga_hs, vga_vs;
reg [3:0] vga_r, vga_g, vga_b;

reg [10:0] counths;
reg [9:0] countvs;
reg valid;
reg [9:0] position;
wire clk20m, div_clk;
wire [9:0] height;

clk20m_div(.clk(clk), .clk20m(clk20m));
always@(posedge clk20m or negedge rst)
begin
	if(!rst)
	begin
		counths <= 11'd0;
		countvs <= 10'd0;
	end
	else
	begin
		counths <= (counths == 11'd800) ? 11'd0 : counths + 11'd1;
		countvs <= (countvs == 10'd525) ? 10'd0 : (counths == 11'd800) ? countvs + 10'd1 : countvs; 
	end
end

always@(posedge clk20m or negedge rst)
begin
	if(!rst)
	begin
		vga_hs <= 1'b0;
		vga_vs <= 1'b0;
		valid <= 1'b0;
	end
	else
	begin
		vga_hs <= (counths < 11'd96) ? 1'b0 : 1'b1;
		vga_vs <= (countvs < 10'd2) ? 1'b0 : 1'b1;
		valid <= (countvs >= 10'd35 && countvs <= 10'd515 && counths >= 11'd144 && counths <= 11'd784) ? 1'b1 : 1'b0;
	end
end

clk_div(.clk(clk), .div_clk(div_clk));
floor_converter(.floor(floor), .height(height));
always@(posedge div_clk)
begin
	if(position > height)
		position <= position - 10'd1;
	else if(position < height)
		position <= position + 10'd1;
	else
		position <= position;
end

always@(posedge clk20m or negedge rst)
begin
	if(!rst)
	begin
		vga_r <= 4'd0;
		vga_g <= 4'd0;
		vga_b <= 4'd0;
	end
	else
	begin
		if(valid)
		begin
			if(counths > 11'd364 && counths < 11'd564 && countvs >= 10'd83) begin
				/*elevator output*/
				if(counths > 11'd464 && counths < 11'd514 && countvs >= position && countvs <= position + 10'd48) begin
					vga_r <= 4'd7;
					vga_g <= 4'd7;
					vga_b <= 4'd7;
				end
				/*number output*/
				else if(counths > 11'd412 && counths <= 11'd416 && countvs > 10'd476 && countvs < 10'd506) begin //1
					if(position >= 10'd456 && position <= 10'd478) begin
						vga_r <= 4'd15;
						vga_g <= 4'd4;
						vga_b <= 4'd7;
					end
					else begin
						vga_r <= 4'd15;
						vga_g <= 4'd10;
						vga_b <= 4'd10;
					end
				end
				else if(counths > 11'd404 && counths < 11'd424 && countvs > 10'd428 && countvs < 10'd458) begin //2
					if((counths > 11'd404 && counths < 11'd420 && countvs > 10'd434 && countvs <= 10'd440) || (counths > 11'd408 && counths < 11'd424 && countvs > 10'd446 && countvs <= 10'd452)) begin
						vga_r <= 4'd12;
						vga_g <= 4'd12;
						vga_b <= 4'd12;
					end
					else begin
						if(position >= 10'd408 && position <= 10'd430) begin
							vga_r <= 4'd15;
							vga_g <= 4'd4;
							vga_b <= 4'd7;
						end
						else begin
							vga_r <= 4'd15;
							vga_g <= 4'd10;
							vga_b <= 4'd10;
						end
					end
				end
				else if(counths > 11'd404 && counths < 11'd424 && countvs > 10'd380 && countvs < 10'd410) begin //3
					if((counths > 11'd404 && counths < 11'd420 && countvs > 10'd386 && countvs <= 10'd392) || (counths > 11'd404 && counths < 11'd420 && countvs > 10'd398 && countvs <= 10'd404)) begin
						vga_r <= 4'd12;
						vga_g <= 4'd12;
						vga_b <= 4'd12;
					end
					else begin
						if(position >= 10'd360 && position <= 10'd382) begin
							vga_r <= 4'd15;
							vga_g <= 4'd4;
							vga_b <= 4'd7;
						end
						else begin
							vga_r <= 4'd15;
							vga_g <= 4'd10;
							vga_b <= 4'd10;
						end
					end
				end
				else if(counths > 11'd404 && counths < 11'd424 && countvs > 10'd332 && countvs < 10'd362) begin //4
					if((counths > 11'd408 && counths < 11'd420 && countvs > 10'd332 && countvs <= 10'd344) || (counths > 11'd404 && counths < 11'd420 && countvs > 10'd350 && countvs <= 10'd362)) begin
						vga_r <= 4'd12;
						vga_g <= 4'd12;
						vga_b <= 4'd12;
					end
					else begin
						if(position >= 10'd312 && position <= 10'd334) begin
							vga_r <= 4'd15;
							vga_g <= 4'd4;
							vga_b <= 4'd7;
						end
						else begin
							vga_r <= 4'd15;
							vga_g <= 4'd10;
							vga_b <= 4'd10;
						end
					end
				end
				else if(counths > 11'd404 && counths < 11'd424 && countvs > 10'd284 && countvs < 10'd314) begin //5
					if((counths > 11'd408 && counths < 11'd424 && countvs > 10'd290 && countvs <= 10'd296) || (counths > 11'd404 && counths < 11'd420 && countvs > 10'd302 && countvs <= 10'd308)) begin
						vga_r <= 4'd12;
						vga_g <= 4'd12;
						vga_b <= 4'd12;
					end
					else begin
						if(position >= 10'd264 && position <= 10'd286) begin
							vga_r <= 4'd15;
							vga_g <= 4'd4;
							vga_b <= 4'd7;
						end
						else begin
							vga_r <= 4'd15;
							vga_g <= 4'd10;
							vga_b <= 4'd10;
						end
					end
				end
				else if(counths > 11'd404 && counths < 11'd424 && countvs > 10'd236 && countvs < 10'd266) begin //6
					if((counths > 11'd408 && counths < 11'd424 && countvs > 10'd242 && countvs <= 10'd248) || (counths > 11'd408 && counths < 11'd420 && countvs > 10'd254 && countvs <= 10'd260)) begin
						vga_r <= 4'd12;
						vga_g <= 4'd12;
						vga_b <= 4'd12;
					end
					else begin
						if(position >= 10'd216 && position <= 10'd238) begin
							vga_r <= 4'd15;
							vga_g <= 4'd4;
							vga_b <= 4'd7;
						end
						else begin
							vga_r <= 4'd15;
							vga_g <= 4'd10;
							vga_b <= 4'd10;
						end
					end
				end
				else if(counths > 11'd404 && counths < 11'd424 && countvs > 10'd188 && countvs < 10'd218) begin //7
					if(counths > 11'd404 && counths < 11'd420 && countvs > 10'd194 && countvs <= 10'd218) begin
						vga_r <= 4'd12;
						vga_g <= 4'd12;
						vga_b <= 4'd12;
					end
					else begin
						if(position >= 10'd168 && position <= 10'd190) begin
							vga_r <= 4'd15;
							vga_g <= 4'd4;
							vga_b <= 4'd7;
						end
						else begin
							vga_r <= 4'd15;
							vga_g <= 4'd10;
							vga_b <= 4'd10;
						end
					end
				end
				else if(counths > 11'd404 && counths < 11'd424 && countvs > 10'd140 && countvs < 10'd170) begin //8
					if((counths > 11'd408 && counths < 11'd420 && countvs > 10'd146 && countvs <= 10'd152) || (counths > 11'd408 && counths < 11'd420 && countvs > 10'd158 && countvs <= 10'd164)) begin
						vga_r <= 4'd12;
						vga_g <= 4'd12;
						vga_b <= 4'd12;
					end
					else begin
						if(position >= 10'd120 && position <= 10'd142) begin
							vga_r <= 4'd15;
							vga_g <= 4'd4;
							vga_b <= 4'd7;
						end
						else begin
							vga_r <= 4'd15;
							vga_g <= 4'd10;
							vga_b <= 4'd10;
						end
					end
				end
				else if(counths > 11'd404 && counths < 11'd424 && countvs > 10'd92 && countvs < 10'd122) begin //9
					if((counths > 11'd408 && counths < 11'd420 && countvs > 10'd98 && countvs <= 10'd104) || (counths > 11'd404 && counths < 11'd420 && countvs > 10'd110 && countvs <= 10'd116)) begin
						vga_r <= 4'd12;
						vga_g <= 4'd12;
						vga_b <= 4'd12;
					end
					else begin
						if(position >= 10'd72 && position <= 10'd94) begin
							vga_r <= 4'd15;
							vga_g <= 4'd4;
							vga_b <= 4'd7;;
						end
						else begin
							vga_r <= 4'd15;
							vga_g <= 4'd10;
							vga_b <= 4'd10;
						end
					end
				end
				
				/*building output*/
				else begin
					vga_r <= 4'd12;
					vga_g <= 4'd12;
					vga_b <= 4'd12;
				end
			end
			/*other building*/
			else if(counths > 11'd644 && counths < 11'd734 && countvs >= 10'd240) begin
				vga_r <= 4'd8;
				vga_g <= 4'd8;
				vga_b <= 4'd8;
			end
			else if(counths > 11'd294 && counths < 11'd344 && countvs >= 10'd400) begin
				vga_r <= 4'd6;
				vga_g <= 4'd6;
				vga_b <= 4'd6;
			end
			/*background*/
			else begin
				vga_r <= 4'd4;
				vga_g <= 4'd9;
				vga_b <= 4'd14;
			end
		end
		else begin		
			vga_r <= 4'd0;
			vga_g <= 4'd0;
			vga_b <= 4'd0;
		end
	end
end

endmodule

module clk20m_div(clk, clk20m);
input clk;
output clk20m;
reg clk20m;
always@(posedge clk)
begin
	clk20m <= ~clk20m;
end
endmodule  

module floor_converter(floor, height);
input [4:0] floor;
output [9:0] height;
reg [9:0] height;
always@(floor)
begin
	if(floor == 5'd0)
		height <= 10'd467; //first floor; 480+35-48
	else if(floor >= 5'd1 && floor <= 5'd9)	
		height <= 10'd48 * (5'd9 - floor) + 10'd83;
	else
		height <= height;
end
endmodule 

module clk_div(clk, div_clk);
input clk;
output div_clk;
reg div_clk;
reg [31:0] count;
always@(posedge clk)
begin
	if(count == 32'd500000) begin
		count <= 32'd0;
		div_clk <= ~div_clk;
	end
	else 
		count <= count + 32'd1;
end
endmodule 