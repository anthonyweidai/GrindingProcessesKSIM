filename="Bat1tgw15kd0Sgap0.5Rgap3w8Hsg0Ssg0Rsg2FT1RA0.3RAM0";
b_field=readtable([filename 'rsdist.csv']);
b_field_all=table2struct(grit_list,'ToScalar',true);
[l_b,w_b]=size(b_field_all);
c_clr=0.1*w_b;
pdz_field=zeros(l_b,w_b+2*c_clr);
res=0.2;
for i=1:l_b
    for j=1:w_b
        if b_field_all(i,j)>0
            b_temp=round(b_field_all(i,j)/res);
            for k=j-b_temp:j+b_temp+c_clr
                if mode == 1
                    pdz_field(i,k)=max(pdz_field(i,k),(b_temp^2-abs(j-k)^2)^0.5 *res);
                elseif mode ==2
                    pdz_field(i,k)=pdz_field(i,k)+(b_temp^2-abs(j-k)^2)^0.5 *res;
                end
            end
        end
    end
end