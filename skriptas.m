% perceptoronas

%
%               ||f1(b1(1))||-- w2(1)--
%           / / ||f2(b1(2))||-- w2(2)--
% x --w1_1 --                           --||f2a(b2)|| -- y == d
%           \ \ ||f3(b1(3))||-- w2(3)--
%               ||f4(b1(4))||-- w2(4)--
%
function daugiasluoksnis_perceptronas()
clear all  % istrinti kintamuosius
clc        % nuvalyti komandini langa
% Perceptrono iejimas (x reiksmes nuo 0 iki 1) 
% iejimo vektorius
x = 0.1 : 1/22 : 1; % 0.1 <= x <= 1
d = isejimo_funkcija(x);

%% Numatomas isejimo funkcijos grafikas
figure(2)
title("Numatomas isejimo funkcijos grafikas d")
plot(x, d, "*", x, d, 'r');
grid on

% dw - svoriu postumio vektorius
% x - iejimas (vienas pavizdys)
% d - norimas isejimas (vienas pavizdys)
% Vienas pavizdys atitinka x(n), kur n skaicius nuo 1 iki x vektoriaus
% ilgio
%% Vieno pavizdio generavimo funkcios
neuronu_skaicius_iejimas = 4;
neuronu_skaicius_isejimas = 1;
% seka  1 | 21 | 3 (taskas.1)
%           22
%           23
%           24
%% Generuojami svoriai pavizdziui
%w(iejimo lygmuo - taskas.1)(neurono skaicius)
w121 = randn(1); % Sinapses svoris i pirma neurona
w122 = randn(1); % Sinapses svoris i antra neurona
w123 = randn(1); % Sinapses svoris i trecia neurona
w124 = randn(1); % Sinapses svoris i ketvirta neurona

% pasleptojo sluoksnio isejimo - isejimo sluoksnio iejimo svoriu
% generavimas
w213 = randn(1); % Sinapses svoris is pirmo neurona
w223 = randn(1); % Sinapses svoris is antro neurona
w233 = randn(1); % Sinapses svoris is trecio neurona
w243 = randn(1); % Sinapses svoris is ketvirto neurona

% pasleptojo sluoksnio neuronu nuokrypiu generavimas
b21 = randn(1);
b22 = randn(1);
b23 = randn(1);
b24 = randn(1);
% isejimo neurono nuokrypio generavimas
b3 = randn(1);
w = [w213 w223 w233 w243 w121 w122 w123 w124];
b = [b3 b21 b22 b23 b24];
% Vienos iteracijos skaiciavimo funkcija 
e = 111;
%%%%%%%%%%%%%%%%%%%%%%%%%% Pagrindinio mokymo ciklo pradzia
%% Ciklas vienam taskui
% programos fragmentas visiems taskams gale
while e ~= 0
    [y, w, b] = pirmyn(x(1), d(1), w, b);
    [dw, db, e] = atgalinis_sklidimas(d(1), x(1), w, b, y);
    [w, b] = atnaujinti(w, b, dw, db);
end
%%%%%%%%%%%%%%%%%%%%%%%%%% Pagrindinio mokymo ciklo pabaiga
    
end

function [y,w1,b1] = pirmyn(x, d, w, b)
%% isskaidomi masyvai
w213 = w(1);
w223 = w(2);
w233 = w(3);
w243 = w(4);
w121 = w(5);
w122 = w(6);
w123 = w(7);
w124 = w(8);

b3 = b(1);
b21 = b(2);
b22 = b(3);
b23 = b(4);
b24 = b(5);
%% neuronu iejimo svoriu funkciju skaiciavimas
% pirmas pasleptojo sluoksnio neuronas
v121 = w121*x + b21;
% antras pasleptojo sluoksnio neuronas
v122 = w122*x + b22;
% trecias pasleptojo sluoksnio neuronas
v123 = w123*x + b23;
% ketvirtas pasleptojo sluoksnio neuronas
v124 = w124*x + b24;

%% pasleptojo sluoksnio aktyvavimo funkcijos
% Sigmoidines funkcijos
% pirmas pasleptojo sluoksnio neurono isejimo funkcija
y21 = 1/(1 + exp(-v121));
% antras pasleptojo sluoksnio neurono isejimo funkcija
y22 = 1/(1 + exp(-v122));
% trecias pasleptojo sluoksnio neurono isejimo funkcija
y23 = 1/(1 + exp(-v123));
% ketvirtas pasleptojo sluoksnio neurono isejimo funkcija
y24 = 1/(1 + exp(-v124));

%% isejimo neuronu svorio funkciju skaiciavimas
v23 = w213*y21 + w223*y22 + w233*y23 + w243*y24 + b3;

%% Isejimo neurono aktyvavimo funkcija - tiesine
yy = v23;

figure(1)
plot(x, yy, 'r*', x, d, 'b*')
grid on
title("Tasku pasiskirstymo grafikas")
legend("esamas isejimas", "norimas isejimas")
axis([0 1 0 2])

%% grazinami pirmo sluoksnio isejimai
y = [yy y21 y22 y23 y24];

%% Grazinami svoriai
w1 = [w213 w223 w233 w243 w121 w122 w123 w124];

%% Grazinami nuokrypiai

b1 = [b3 b21 b22 b23 b24];

end

function [dw, db, e] = atgalinis_sklidimas(d, x, w, b, y)
%% isskaidomi masyvai
w213 = w(1);
w223 = w(2);
w233 = w(3);
w243 = w(4);
w121 = w(5);
w122 = w(6);
w123 = w(7);
w124 = w(8);

b3 = b(1);
b21 = b(2);
b22 = b(3);
b23 = b(4);
b24 = b(5);

yy = y(1);
y21 = y(2);
y22 = y(3);
y23 = y(4);
y24 = y(5);
%% Atgalinio sklidimo algoritmas
%% skaiciojama klaida
e = d - yy; % Skirtumas tarp norimos ir esamos vertes

%% Svorio atnaujinimo funkcija
sigma2 = -e; % lokalus gradientas
miu = 0.01; % mokymo sparta

%% svoriu atnaujinimas isejimo sluoksnio
dw213 = miu*sigma2*y21;
dw223 = miu*sigma2*y22;
dw233 = miu*sigma2*y23;
dw243 = miu*sigma2*y24;
db2 = miu*e;
%% svoriu atnaujinimas pasleptam sluoksniui
% pirmo pasleptojo sluoksnio neurono gradientas
sigma21= y21*(1 - y21)*(sigma2*w213); 
% antro pasleptojo sluoksnio neurono gradientas
sigma22= y22*(1 - y22)*(sigma2*w223); 
% trecio pasleptojo sluoksnio neurono gradientas
sigma23= y23*(1 - y23)*(sigma2*w233); 
% ketvrto pasleptojo sluoksnio neurono gradientas
sigma24= y24*(1 - y24)*(sigma2*w243);

%% svoriu atnaujinimas paslepto sluoksnio iejimui
dw121 = miu*sigma21*x;
dw122 = miu*sigma22*x;
dw123 = miu*sigma23*x;
dw124 = miu*sigma24*x;
%% Skaiciojami nuokrypiu santykiai
db21 = miu*y21*(1 - y21)*(e*w213);
db22 = miu*y23*(1 - y22)*(e*w223);
db23 = miu*y23*(1 - y23)*(e*w233);
db24 = miu*y24*(1 - y24)*(e*w243);
%% atnaujinti svoriai grazinami vektoriu
dw = [dw213 dw223 dw233 dw243 dw121 dw122 dw123 dw124];
%% atnaujinti nuokrypiai grazinami vektoriu
db = [db2 db21 db22 db23 db24];

end

%% svoriu ir nuokrypiu atnaujinimo funkcija
function [w, b] = atnaujinti(w, b, dw, db)
% isskaidomi masyvai
dw213 = dw(1);
dw223 = dw(2);
dw233 = dw(3);
dw243 = dw(4);
dw121 = dw(5);
dw122 = dw(6);
dw123 = dw(7);
dw124 = dw(8);

db2 = db(1);
db21 = db(2);
db22 = db(3);
db23 = db(4);
db24 = db(5);

w213 = w(1);
w223 = w(2);
w233 = w(3);
w243 = w(4);
w121 = w(5);
w122 = w(6);
w123 = w(7);
w124 = w(8);

b3 = b(1);
b21 = b(2);
b22 = b(3);
b23 = b(4);
b24 = b(5);
%% atnaujinami svoriai

w121 = w121 + dw121;
w122 = w122 + dw122;
w123 = w123 + dw123;
w124 = w124 + dw124;
w213 = w213 + dw213;
w223 = w223 + dw223;
w233 = w233 + dw233;
w243 = w243 + dw243;

%% Atnaujinami nuokrypiai
b3 = b3 + db2;
b21 = b21 + db21;
b22 = b22 + db22;
b23 = b23 + db23;
b24 = b24 + db24;

%% Atnaujinti svoriai ir nuokrypaii surenkami i vektorius
w = [w213 w223 w233 w243 w121 w122 w123 w124];
b = [b3 b21 b22 b23 b24];
end


function d = isejimo_funkcija(x)
    % norima isejimo funkcija pagal uzduoti
    N = length(x);
    for n = 1 : N
        d(n) = (1 + 0.6*sin(2*pi*x(n)*0.7)) + 0.3*sin(2*pi*x(n))/2;
    end
end

% 
% 
% for n = 1 : length(x)
%      iteracija = 1 %% jeigu pirma iteracija - svoriai atsitiktiniai
%      while e ~= 0
%        if iteracija == 1
%          %% Generuojami svoriai pavizdziui
%          %w(iejimo lygmuo - taskas.1)(neurono skaicius)
%          w121 = randn(1); % Sinapses svoris i pirma neurona
%          w122 = randn(1); % Sinapses svoris i antra neurona
%          w123 = randn(1); % Sinapses svoris i trecia neurona
%          w124 = randn(1); % Sinapses svoris i ketvirta neurona
% 
%          % pasleptojo sluoksnio isejimo - isejimo sluoksnio iejimo svoriu
%          % generavimas
%          w213 = randn(1); % Sinapses svoris is pirmo neurona
%          w223 = randn(1); % Sinapses svoris is antro neurona
%          w233 = randn(1); % Sinapses svoris is trecio neurona
%          w243 = randn(1); % Sinapses svoris is ketvirto neurona
% 
%          % pasleptojo sluoksnio neuronu nuokrypiu generavimas
%          b21 = randn(1);
%          b22 = randn(1);
%          b23 = randn(1);
%          b24 = randn(1);
%          % isejimo neurono nuokrypio generavimas
%          b3 = randn(1);
%          w = [w213 w223 w233 w243 w121 w122 w123 w124];
%          b = [b3 b21 b22 b23 b24];
%        end
%          % Vienos iteracijos skaiciavimo funkcija 
%          [y, w, b] = pirmyn(x(n), d(n), w, b);
%          [dw, db, e] = atgalinis_sklidimas(d(n), x(n), w, b, y);
%          [w, b] = atnaujinti(w, b, dw, db);
%      end
%      e = 1111 %%% bet koks skaicius iteracijos pasikartojimui
% end
     


