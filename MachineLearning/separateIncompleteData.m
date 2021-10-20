IncompDat={};
fid=fopen('Incompletedata.txt');
count=1;
while ~feof(fid)
    IncompDat(count)={fgetl(fid)};
    count=count+1;
end

x=dir('CBF/*PTST*');