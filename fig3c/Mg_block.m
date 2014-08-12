function B = Mg_block(V)
Mg_con = 1;
B = 1./(1+exp(-0.062*V)*(Mg_con/3.57));
end