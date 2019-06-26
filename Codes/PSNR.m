function psnr_Value = PSNR(A,B)
% PSNR (Peak Signal to noise ratio)

    if (size(A) ~= size(B))
        error('The size of the 2 matrix are unequal')
        psnr_Value = -1;
        return;
    elseif (A == B)
        disp('Images are identical: PSNR has infinite value')
        psnr_Value = Inf;
        return;
    else
    % Calculate MSE, mean square error.
        mseImage = (double(A) - double(B)) .^ 2;
        [rows,columns,depth ] = size(A);
        mse = sum(mseImage(:)) / (rows * columns * depth);
        % Calculate PSNR (Peak Signal to noise ratio)
        psnr_Value = 10 * log10( 255^2 / mse);
    end
end

