% 你在输入目录下有以(0,0,255)像素表示透明的三通道png。这个脚本会在输出目录下生成替换为透明像素的四通道png。
% 定义输入和输出目录
inputDir = 'output_3chan';
outputDir = 'output_4chan';

% 确保输出目录存在，如果不存在则创建
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

% 获取指定目录下所有的png文件名
filePattern = fullfile(inputDir, "*.png");
pngFiles = dir(filePattern);

for k = 1:length(pngFiles)
    % 构建完整的文件路径
    baseFileName = pngFiles(k).name;
    fullInputFileName = fullfile(inputDir, baseFileName);
    
    % 读取原始图像
    [img, map, alpha] = imread(fullInputFileName);
    
    % 获取图像尺寸
    [rows, cols, channels] = size(img);
    
    % 检查图像是否已经有 alpha 通道
    if isempty(alpha)
        % 如果没有 alpha 通道，创建一个
        alpha = 255 * ones(rows, cols, 'uint8'); 
    end
    
    % 分离图像的颜色通道
    red = img(:,:,1);
    green = img(:,:,2);
    blue = img(:,:,3);
    
    % 找到 RGB 值为 [0,0,255] 的像素
    mask = ((red == 0) & (green == 0) & (blue == 255))|((red == 1) & (green == 1) & (blue == 255));
    
    % 将这些像素的 alpha 通道值设为 0（完全透明）
    alpha(mask) = 0;
    
    % 构建输出文件路径
    fullOutputFileName = fullfile(outputDir, baseFileName);
    
    % 保存修改后的图像
    imwrite(img, fullOutputFileName, 'Alpha', alpha);
end
