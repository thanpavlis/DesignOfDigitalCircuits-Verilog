module calculator(sys_clk,reset,keyb_clk,keyb_data,HEX7,HEX6,HEX5,HEX4,HEX3,HEX2);
   input sys_clk,reset,keyb_data;//οι είσοδοι του κυκλώματος
   inout keyb_clk;//keyb_clk που λειτουργεί και σαν είσοδος και σαν έξοδος
   output reg [6:0] HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;//οι έξοδοι του κυκλώματος μας για την αναπαράσταση της πράξης
   parameter [2:0] WAIT_OPERAND1=3'b000,WAIT_OPERATOR=3'b001,WAIT_OPERAND2=3'b010,WAIT_EQ=3'b011,WAIT_F0=3'b100,AFTER_F0=3'b101;//όλες οι καταστάσεις του state machine
   
   reg [5:0] keyb_clk_samples;//ο right shift register που θα χρησιμοποιήσουμε για την δειγματοληψία του ρολογιού του πληκτρολογίου
   reg [10:0] keyb_data_reg;//o right shift register που θα χρησιμοποιήσουμε για την δειγματοληψία των δεδομένων που μας στέλνει το πληκτρολόγιο
   reg [7:0] keyb_data_8bit;//register για την αποθήκευση και την αποκωδικοποίηση των 8-bit από τα 11 που στέλνει το πληκτρολόγιο για κάθε κουμπί
   
   wire [5:0] result;//wire που θα χρησιμοποιήσουμε για την αποθήκευση του αποτελέσματος της πράξης
   wire [5:0] mux;//θα οδηγεί στην είσοδο του δεύτερου επιπέδου αποκωδικοποιητή το τελούμενο ή το άθροισμα ανάλογα με την τρέχουσα κατάσταση του fsm
   reg [5:0] a;//register για την αποθήκευση της αποκωδικοποιημένης τιμής του πρώτου αριθμού
   reg [5:0] b;//register για την αποθήκευση της αποκωδικοποιημένης τιμής του δεύτερου αριθμού
   reg [5:0] c;//register για την αποθήκευση της αποκωδικοποιημένης τιμής
   reg op;//καταχωρητής του 1-bit ο οποίος θα καθορίζει την πράξη που θα εκτελεστεί
   
   //καταχωρητές που χρησιμοποιεί το fsm
   reg [2:0] next_calc_state;
   reg [2:0] state;
   
   //καταχωρητές που χρησιμοποιεί ο δεύτερος αποκωδικοποιητής για την αποθήκευση των τιμών των displays
   reg [6:0] disp1,disp2;
   
   
   assign keyb_clk=(!keyb_data_reg[0])?1'b0:1'bz;//το πληκτρολόγιο δεν μπορεί να στείλει δεδομένα πριν επναρχικοποιηθεί ο keyb_data_reg register με άσσους   
   
   assign mux=(next_calc_state==WAIT_EQ)?result:c;//αν περιμένω αποτέλεσμα θα στείλω στον αποκωδικοποιητή το άθροισμα, αλλιώς το τελούμενο της πράξης
   
   assign result=op?a+(~b)+1'b1:a+b;//αν η τιμή του op είναι 1 κάνουμε αφαίρεση, αλλιώς κάνουμε πρόσθεση
   
   
   
   //σε αυτό το always περιγράφεται ο τρόπος λειτουργίας του keyb_clk_samples register
   always @(posedge sys_clk or posedge reset)
    begin
      if(reset)
	     keyb_clk_samples<=6'b000000;
	  else//ολίσθηση των bits προς τα δεξιά
	     keyb_clk_samples<={keyb_clk,keyb_clk_samples[5:1]};
    end
		 
   //σε αυτό το always περιγράφεται ο τρόπος λειτουργίας του keyb_data_reg register
   always @(posedge sys_clk or posedge reset)
    begin
      if(reset)
	     keyb_data_reg<=11'b11111111111;
	  else if(!keyb_data_reg[0])//αν ισχύει έχω λάβει τα 11-bit και κάνω αρχικοποίηση ξανά για την λήψη της επόμενης 11-abiths ποσότητας
	    begin
          keyb_data_8bit<=keyb_data_reg[8:1];//κρατάμε τα 8-bit ώστε να τα αποκωδικοποιήσουμε στη συνέχεια	
		  keyb_data_reg<=11'b11111111111;//αρχικοποίηση ξανά για την λήψη της επόμενης 11-abiths ποσότητας
	    end
	  else if(keyb_clk_samples==6'b000111)//αν έχει ανιχνευθεί μετάβαση από 1 σε 0 του keyb_clk τοτέ δειγματολειπτώ το keyb_data ολισθαίνοντας τα παλιά bits προς τα δεξιά
		 keyb_data_reg<={keyb_data,keyb_data_reg[10:1]};	 
    end
		 
   //σε αυτό το always περιγράφεται ο αποκωδικοποιητής ο οποίος παίρνει σαν είσοδο τα 8-bit από τα δεδομένα του πληκτρολογίου και επιστρέφει την αντίστοιχη 6-bit αναπαράσταση του δυαδικού αριθμού 
   always @(*)
    begin
		case(keyb_data_8bit)
		    8'h16: c<=6'd1;
		    8'h1E: c<=6'd2;
		    8'h26: c<=6'd3;
		    8'h25: c<=6'd4;
		    8'h2E: c<=6'd5;
		    8'h36: c<=6'd6;
		    8'h3D: c<=6'd7;
		    8'h3E: c<=6'd8;
		    8'h46: c<=6'd9;
		    8'h45: c<=6'd0;
		    8'h69: c<=6'd1;
		    8'h72: c<=6'd2;
		    8'h7A: c<=6'd3;
		    8'h6B: c<=6'd4;
		    8'h73: c<=6'd5;
		    8'h74: c<=6'd6;
		    8'h6C: c<=6'd7;
		    8'h75: c<=6'd8;
		    8'h7D: c<=6'd9;
		    8'h70: c<=6'd0;
		    default: c<=6'b100000;//περίπτωση που πατήθηκε κουμπί που δεν αντιστοιχεί σε αριθμό
		endcase
	end
		 	 
   //σε αυτό το always περιγράφεται ο αποκωδικοποιητής ο οποίος παίρνει σαν είσοδο ανάλογα με την κατάσταση του fsm είτε ένα τελούμενο είτε το άθροισμα της πρόσθεσης και καθορίζει τα αντίστοιχα 7-segment displays
   always @(*)
    begin
		case(mux)//o καταχωρητής disp1 αντιστοιχεί σε πρόσημο αν είναι αρνητικό το αποτέλεσμα ή σε αριθμό αν το αποτέλεσμα είναι διψήφιο, ενώ ο disp2 στον αριθμό
		   -6'd9: 
		     begin
               disp1<=7'b0111111; 
			   disp2<=7'b0010000;
			 end			   
		   -6'd8:
		     begin
               disp1<=7'b0111111; 
			   disp2<=7'b0000000;
			 end	
		   -6'd7:
		     begin
               disp1<=7'b0111111; 
			   disp2<=7'b1111000;
			 end	
		   -6'd6:
		     begin
               disp1<=7'b0111111; 
			   disp2<=7'b0000010;
			 end	
		   -6'd5:
		     begin
               disp1<=7'b0111111; 
			   disp2<=7'b0010010;
			 end	
		   -6'd4:
		     begin
               disp1<=7'b0111111; 
			   disp2<=7'b0011001;
			 end	
		   -6'd3:
		     begin
               disp1<=7'b0111111; 
			   disp2<=7'b0110000;
			 end	
		   -6'd2:
		     begin
               disp1<=7'b0111111; 
			   disp2<=7'b0100100;
			 end	
		   -6'd1:
		     begin
               disp1<=7'b0111111; 
			   disp2<=7'b1111001;
			 end	
		    6'd0:
			 begin
               disp1<=7'b1111111; 
			   disp2<=7'b1000000;
			 end	
		    6'd1:
			 begin
               disp1<=7'b1111111; 
			   disp2<=7'b1111001;
			 end	
		    6'd2:
			 begin
               disp1<=7'b1111111; 
			   disp2<=7'b0100100;
			 end
		    6'd3:
			 begin
               disp1<=7'b1111111; 
			   disp2<=7'b0110000;
			 end
		    6'd4:
			 begin
               disp1<=7'b1111111; 
			   disp2<=7'b0011001;
			 end
		    6'd5:
			 begin
               disp1<=7'b1111111; 
			   disp2<=7'b0010010;
			 end
		    6'd6:
			 begin
               disp1<=7'b1111111; 
			   disp2<=7'b0000010;
			 end
		    6'd7:
			 begin
               disp1<=7'b1111111; 
			   disp2<=7'b1111000;
			 end
		    6'd8:
			 begin
               disp1<=7'b1111111; 
			   disp2<=7'b0000000;
			 end
		    6'd9:
			 begin
               disp1<=7'b1111111; 
			   disp2<=7'b0010000;
			 end
		    6'd10:
			 begin
               disp1<=7'b1111001; 
			   disp2<=7'b1000000;
			 end
		    6'd11:
			 begin
               disp1<=7'b1111001; 
			   disp2<=7'b1111001;
			 end
		    6'd12:
			 begin
               disp1<=7'b1111001; 
			   disp2<=7'b0100100;
			 end
		    6'd13:
			 begin
               disp1<=7'b1111001; 
			   disp2<=7'b0110000;
			 end
		    6'd14:
			 begin
               disp1<=7'b1111001; 
			   disp2<=7'b0011001;
			 end
		    6'd15:
			 begin
               disp1<=7'b1111001; 
			   disp2<=7'b0010010;
			 end
		    6'd16:
			 begin
               disp1<=7'b1111001; 
			   disp2<=7'b0000010;
			 end
		    6'd17:
			 begin
               disp1<=7'b1111001; 
			   disp2<=7'b1111000;
			 end
		    6'd18:
			 begin
               disp1<=7'b1111001; 
			   disp2<=7'b0000000;
			 end
		    default:
			 begin
               disp1<=7'b0000100; 
			   disp2<=7'b0000100;
			 end
		endcase
	end	 
		 	 
    //υλοποίηση του finite state machine
	always @(posedge sys_clk or posedge reset)
	 begin
	  if(reset)//αρχικοποιήσεις του καταχωρητή next_calc_state και των 7-segments
	     begin		
			HEX2<=7'b1111111;
			HEX3<=7'b1111111;
			HEX4<=7'b1111111;
			HEX5<=7'b1111111;
			HEX6<=7'b1111111;
			HEX7<=7'b1111111;
			next_calc_state<=WAIT_OPERAND1;
		 end
	  else if(!keyb_data_reg[0])//αν ισχύει τότε ο register έχει γεμίσει, άρα έχει ληφθεί ένας scan κωδικός
        case(next_calc_state)
		   WAIT_OPERAND1: begin//τότε δείχνουμε στο 1ο 7-segment τον αριθμό που πατήθηκε, αποθηκεύουμε στον καταχωρητή a την αποκωδικοποιημένη τιμή 
							  HEX2<=7'b1111111;
							  HEX3<=7'b1111111;
							  HEX4<=7'b1111111;
							  HEX5<=7'b1111111;
							  HEX6<=7'b1111111;
							  if(c[5]!=1'b1)//αν έχει πατηθεί κουμπί που αντιστοιχεί σε αριθμό
								  begin
									 a<=c;//αποθηκεύω την αποκωδικοποιημένη τιμή στον καταχωρητή a
									 next_calc_state<=WAIT_F0;//αλλάζουμε την τρέχουσα κατάσταση του fsm
								  end
							 HEX7<=disp2;//δείχνω στο πρώτο 7-segment την έξοδο του 2ου αποκωδικοποιητή είτε θα είναι αριθμός είτε το e
							 state<=WAIT_OPERAND1;//αποθηκεύουμε την κύρια κατάσταση του fsm
					      end
		   WAIT_OPERATOR: begin
							 case(keyb_data_8bit)
								8'h79: begin
										   HEX6<=7'b0111001;//αν πατηθεί το + δείχνουνε το αντίστοιχο σύμβολο στο αντίσοιχο 7-segment προσήμου
										   op<=1'b0;//για op=0 εκτελείται η πράξη της πρόσθεσης
										   next_calc_state<=WAIT_F0;
										 end
								8'h7B: begin
										   HEX6<=7'b0111111;//αν πατηθεί το - δείχνουμε το - στο αντίστοιχο 7-segment προσήμου
										   op<=1'b1;//για op=0 εκτελείται η πράξη της αφαίρεσης
										   next_calc_state<=WAIT_F0;
										 end
								default: HEX6<=7'b0000100;//δείχνουμε στο αντίστοιχο 7-segment το e
							 endcase
							 state<=WAIT_OPERATOR;
						  end 					
		   WAIT_OPERAND2: begin
							   if(c[5]!=1'b1)//έχει πατηθεί αριθμός
									begin
									   b<=c;//αποθηκεύω την αποκωδικοποιημένη τιμή στον καταχωρητή b
									   next_calc_state<=WAIT_F0;
									end   
							   HEX5<=disp2;//δείχνουμε είτε αριθμό είτε το e στο αντίστοιχο 7-segment ανάλογα με την έξοδο του δεύτερου αποκωδικοποιητή
							   state<=WAIT_OPERAND2;
			              end 
		   WAIT_EQ: begin
					   if(keyb_data_8bit==8'h55)//αν πατήθηκε το πλήκτρο = ώστε να υπολογιστεί το αποτέλεσμα
							begin
							   HEX4<=7'b0111110;//αν πατηθεί το = δείχνουμε το = στο αντίστοιχο 7-segment του ίσον
							   HEX3<=disp1;//δείχνουμε στο 5ο 7-segment το αποτέλεσμα του αποκωδικοποιητή, δηλαδή αριθμό ή πρόσημο ή τίποτα
							   HEX2<=disp2;//δείχνουμε στο 5ο 7-segment το αποτέλεσμα του αποκωδικοποιητή που είναι αριθμός
							   next_calc_state<=WAIT_F0;
							end
					   else//αν πατήθηκε λάθος πλήκτρο
							HEX4<=7'b0000100;//δείχνουμε στο αντίστοιχο 7-segment το e   
					   state<=WAIT_EQ;
					end
		   WAIT_F0: begin
					  if(keyb_data_8bit==8'hF0)//έχουμε λάβει τον scan κωδικό F0 οπότε ο επόμενος κωδικός θα είναι ο scan κωδικός του πλήκτρου
						next_calc_state<=AFTER_F0;
			        end
		   AFTER_F0: begin
						case(state)
						   WAIT_OPERAND1:next_calc_state<=WAIT_OPERATOR; 
						   WAIT_OPERATOR:next_calc_state<=WAIT_OPERAND2;
						   WAIT_OPERAND2:next_calc_state<=WAIT_EQ;
						   default:next_calc_state<=WAIT_OPERAND1;
						endcase   
		             end   
		   default: begin               
					   HEX2<=7'b1111111;
					   HEX3<=7'b1111111;
					   HEX4<=7'b1111111;
					   HEX5<=7'b1111111;
					   HEX6<=7'b1111111;
					   HEX7<=7'b1111111;
					   next_calc_state<=WAIT_OPERAND1;
					end
		endcase
	 end
endmodule