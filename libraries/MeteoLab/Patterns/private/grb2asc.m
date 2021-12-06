%*******Contenido de dmn****************************
dmn.lvl=[1000,925,850];
dmn.tim=[18];
dmn.par=[130];
%*******Contenido de dmn****************************
indObj=1:5538;
[YY,MM,DD]=datevec((indObj)+datenum(1979,1,1)-1);

Camino2='./asc/';
DMN.lon=[-10:4];
DMN.lat=[44:-1:36];
DMN.lvl=[];
DMN.tim=[];
DMN.par=[];

nP=size(dmn.par,2);
nH=size(dmn.tim,2);
nN=size(dmn.lvl,2);
name=[];
%diamax=fix(dmn.tim(nH)/24);
for P=1:nP
   for H=1:nH
      hora=dmn.tim(H);
      for N=1:nN
         name=[Camino2 'tim' num2str(hora,'%02d') '/par' num2str(dmn.par(P),'%03d') '_' num2str(dmn.lvl(N),'%04d') '.asc'];
         disp(name);
         DMN.par=dmn.par(P);
         DMN.lvl=dmn.lvl(N);
			DMN.tim=dmn.tim(H);
         campo=getGrb(DMN);
         fid=fopen(name,'wb');
         for i=1:size(campo,1)
            fprintf(fid,'%04d%02d%02d',YY(i),MM(i),DD(i));
            fprintf(fid,' %8g',campo(i,:));
            fprintf(fid,'\n');
         end
         fclose(fid);
         
      end
   end
end
