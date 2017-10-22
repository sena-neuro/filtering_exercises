
% load image
imorig = imread( 'img.jpg' );
imorig = rgb2gray(imorig);

[ height, width ] = size( imorig );

% Add Gaussian noise with zero mean and a few different variance values
gaussnoise = 10 * randn( height, width );                                  % variance is 10
imgaussnoise = uint8( double( imorig ) + gaussnoise );
figure(); imshow( imgaussnoise );
title( 'with gaussian noise' );

% Apply mean filters with a few different window sizes
mask = fspecial( 'average', [ 5 5 ] );
imgaussnoise_5x5_mean_filtered = imfilter( imgaussnoise, mask );
figure(); imshow( imgaussnoise_5x5_mean_filtered );
title( 'with gaussian noise after 5x5 mean filter' );


% Apply Gaussian filters with a few different window sizes
% 5x5 window with standard deviation 2
mask = fspecial( 'gaussian', [ 5 5 ], 2 );
imgaussnoise_5x5_gauss_filtered = imfilter( imgaussnoise, mask );
figure( ); imshow( imgaussnoise_5x5_gauss_filtered );
title( 'with gaussian noise after 5x5 gaussian filter' );

% Apply median filters with a few different window sizes
imgaussnoise_5x5_median_filtered = medfilt2( imgaussnoise, [ 5 5 ] );
figure( ); imshow( imgaussnoise_5x5_median_filtered );
title( 'with gaussian noise after 5x5 median filter' );

% Add salt and pepper noise with a few different values for probability of corruption
imspnoise = imorig;
noisypixels = rand( height, width );
salt = find( noisypixels <= ( 1 / 50 ) );   % convert pixels with 1/50 probability
pepper = find( noisypixels >= ( 49 / 50 ) );    % convert pixels with 1/50 probability
imspnoise( salt ) = 255;
imspnoise( pepper ) = 0;
figure(); imshow( imspnoise );
title( 'with salt-and-pepper noise' );

% Apply mean filters with a few different window sizes
mask = fspecial( 'average', [ 5 5 ] );
imspnoise_5x5_mean_filtered = imfilter( imspnoise, mask );
figure( ); imshow( imspnoise_5x5_mean_filtered );
title( 'with salt-and-pepper noise after 5x5 mean filter' );

% Apply Gaussian filters with a few different window sizes
mask = fspecial( 'gaussian', [ 5 5 ], 2 );                                 % variance is 2
imspnoise_5x5_gauss_filtered = imfilter( imspnoise, mask );
figure(); imshow( imspnoise_5x5_gauss_filtered );
title( 'with salt-and-pepper noise after 5x5 gaussian filter' );

% Apply median filters with a few different window sizes
imspnoise_5x5_median_filtered = medfilt2( imspnoise, [ 5 5 ] );
figure(); imshow( imspnoise_5x5_median_filtered );
title( 'with salt-and-pepper noise after 5x5 median filter' );

% Compute the Fourier transform of the image and visualize the magnitude and phase

% magnitude
imfourier = abs( fftshift( fft2( double( imorig ) ) ) );
figure();
% scale image range for visualization
imshow( 255 * ( imfourier - min( imfourier(:) ) ) / ( max( imfourier(:) ) - min( imfourier(:) ) ) );
title( 'Fourier spectrum of the image' );

% phase
figure(); 
imphase = angle(fftshift(fft2( double( imorig ) ) ) );
imshow(imphase);
title( 'Phase' );

% Mask different parts of the magnitude and reconstruct the image with the modified magnitude and the original phase

% Create 3 masks
mask1 = fspecial('gaussian', size(imfourier), 70);

mask2 = fspecial('average', size(imfourier));

mask3 = ones(size(imfourier));
mask3(450:550, 500:600) = 0;
imshow(mask3);

% Apply masks
masked1 = (imfourier .* mask1);
figure, imshow(255 * ( masked1 - min( masked1(:) ) ) / ( max( masked1(:) ) - min( masked1(:) ) ) );
title('Fourier magnitude masked with gaussian filter with the variance of 70');

masked1_reconstructed = ifft2( abs(masked1).* exp(1i*imphase));
amin = min(min(abs(masked1_reconstructed)));
amax = max(max(abs(masked1_reconstructed)));

figure, imshow(abs(masked1_reconstructed), [amin amax]), colormap gray
title('Image reconstructed from gaussian');

masked2 = imfourier .* mask2;
figure, imshow(255 * ( masked2 - min( masked2(:) ) ) / ( max( masked2(:) ) - min( masked2(:) ) ) );
title('Fourier magnitude masked with average filter ');

masked2_reconstructed = ifft2( abs(masked2).* exp(1i*imphase));
bmin = min(min(abs(masked2_reconstructed)));
bmax = max(max(abs(masked2_reconstructed)));

figure, imshow(abs(masked2_reconstructed), [bmin bmax]), colormap gray
title('Image reconstructed from average filter');

% Fourier magnitude masked
masked3 = (mask3 .* imfourier);
figure, imshow(255 * ( masked3 - min( masked3(:) ) ) / ( max( masked3(:) ) - min( masked3(:) ) ) );
title('Fourier magnitude masked with box filter');

masked3_reconstructed = ifft2( abs(masked3).* exp(1i*imphase));
cmin = min(min(abs(masked3_reconstructed)));
cmax = max(max(abs(masked3_reconstructed)));

figure, imshow(abs(masked3_reconstructed), [cmin cmax]), colormap gray
title('Image reconstructed from box filter');


% Save figures
saveas(1,'gauss_noise.png');
saveas(2,'gn_mean_filter.png');
saveas(3,'gn_gaussian_filter.png');
saveas(4,'gn_median_filter.png');
saveas(5,'salt_pepper_noise.png');
saveas(6,'sp_mean_filter.png');
saveas(7,'sp_gaussian_filter.png');
saveas(8,'sp_median_filter.png');
saveas(9, 'fourier_magnitude.png');
saveas(10, 'fourier_phase.png');
saveas(12, 'fourier_masked_1.png');
saveas(14, 'fourier_masked_2.png');
saveas(16, 'fourier_masked_3.png');

close all;