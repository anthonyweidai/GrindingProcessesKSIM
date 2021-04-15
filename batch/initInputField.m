function InputField = initInputField(FOI)
if strcmp(FOI, 'FrustumRarea')||strcmp(FOI, 'EllipsoidRarea')||...
        strcmp(FOI, 'Default')||strcmp(FOI, 'Edges')
    InputField = 'Rarea';
else
    InputField = FOI;
end
end