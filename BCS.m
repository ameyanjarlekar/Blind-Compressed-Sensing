%%
tic
image = imread('C:\Users\Ameya\Desktop\AIP\images\boat.png');
[p q] = size(image);
sampling_ratio=0.5;
image = double(image);
pred_img = zeros(p,q);
pred_init = zeros(p,q);
block_size=8;
x = zeros(block_size^2,(p/block_size)^2);
y = zeros(block_size^2*sampling_ratio,(p/block_size)^2);
%sensing_matrix = randi([0 1],block_size^2*sampling_ratio,block_size^2,(p/block_size)^2)/block_size*sqrt(2);
sensing_matrix = randn(block_size^2*sampling_ratio,block_size^2,(p/block_size)^2)/block_size*sqrt(2);

for i =1:p/block_size
    for j=1:p/block_size
        int = image(block_size*(i-1)+1:block_size*i,block_size*(j-1)+1:block_size*j);
        x(:,p/block_size*(i-1)+j) = int(:);
        y(:,p/block_size*(i-1)+j) = sensing_matrix(:,:,p/block_size*(i-1)+j)*x(:,p/block_size*(i-1)+j);
        
    end
end
%%
T = 150;
%lr = 0.000000001;
lr = 0.0001;
reg = 0.01;
overcompleteness = 1;
lim = 0.95;
n = block_size^2;
D = randn(n,n)/sqrt(n);
% %D = dctmtx(n);
[dict,img,init_img] = bcs_ALGO(y,sensing_matrix,T,reg,lim,overcompleteness,lr,D);
%%
k=1;
for i =1:p/block_size
    for j=1:p/block_size
        pred_img(block_size*(i-1)+1:block_size*i,block_size*(j-1)+1:block_size*j) = reshape(img(:,k),8,8);
        k = k+1;
    end
end
k=1;
for i =1:p/block_size
    for j=1:p/block_size
        pred_init(block_size*(i-1)+1:block_size*i,block_size*(j-1)+1:block_size*j) = reshape(init_img(:,k),8,8);
        k = k+1;
    end
end

figure(2),
imshow(uint8(pred_img))
figure(1),
imshow(uint8(image))
figure(3),
imshow(uint8(pred_init))
pred_img = uint8(pred_img);
image = uint8(image);
pred_init = uint8(pred_init);
PSNR = psnr(pred_img,image)
PSNR_init = psnr(pred_init,image)
toc