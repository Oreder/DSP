function Lab09
  clear, clc, close all 
  adress = '.\src\im01.bmp';
  img = imread(adress);
  H = fspecial('motion', 54, 70);
  rec = deconvblind(img, H);

  subplot(1,2,1), subimage(img), title('Source');
  subplot(1,2,2), subimage(rec), title('Recovered');
end