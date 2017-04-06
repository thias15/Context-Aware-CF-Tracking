%
%  Context-Aware Correlation Filters
%
%  Written by Luca Bertinetto, 2016
%  Adapted by Matthias Mueller, 2016
%
%  This function takes care of setting up parameters, loading video
%  information and computing precisions. For the actual tracking code,
%  check out the TRACKERMAIN.m function.
%

function run_tracker(video, start_frame)
% RUN_TRACKER  is the external function of the tracker - does initialization and calls trackerMain

	%path to the videos (you'll be able to choose one with the GUI).
	base_path = 'sequences/';
    
	%default settings
	if nargin < 1, video = 'Skiing'; end
	if nargin < 2, start_frame = 1; end
    if nargin < 3, show_plots = 1; end
    
    %% Read params.txt
    params = readParams('params.txt');
	%% load video info
    sequence_path = fullfile(base_path,video);
    img_path = fullfile(sequence_path, 'img');
    %% Read files
    text_files = dir([sequence_path '*_frames.txt']);
    if(~isempty(text_files))
        f = fopen([sequence_path text_files(1).name]);
        frames = textscan(f, '%f,%f');
        fclose(f);
    else
        frames = {};
    end
    if exist('start_frame')
        frames{1} = start_frame;
    else
        frames{1} = 1;
    end
    
   
    params.bb_VOT = csvread(fullfile(sequence_path, 'groundtruth_rect.txt'));
    region = params.bb_VOT(frames{1},:);
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % read all the frames in the 'imgs' subfolder
    dir_content = dir(fullfile(sequence_path, 'img'));
    % skip '.' and '..' from the count
    n_imgs = length(dir_content) - 2;
    img_files = cell(n_imgs, 1);
    for ii = 1:n_imgs
        img_files{ii} = dir_content(ii+2).name;
    end
       
    img_files(1:start_frame-1)=[];

    im = imread(fullfile(img_path, img_files{1}));
    % is a grayscale sequence ?
    if(size(im,3)==1)
        params.grayscale_sequence = true;
    end

    params.img_files = img_files;
    params.img_path = img_path;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if(numel(region)==8)
        % polygon format
        [cx, cy, w, h] = getAxisAlignedBB(region);
    else
        x = region(1);
        y = region(2);
        w = region(3);
        h = region(4);
        cx = x+w/2;
        cy = y+h/2;
    end

    % init_pos is the centre of the initial bounding box
    params.init_pos = [cy cx];
    params.target_sz = round([h w]);
    [params, bg_area, fg_area, area_resize_factor] = initializeAllAreas(im, params);
	if params.visualization
		params.videoPlayer = vision.VideoPlayer('Position', [100 100 [size(im,2), size(im,1)]+30]);
	end
    % in runTracker we do not output anything
	params.fout = -1;
	% start the actual tracking
	results = trackerMain(params, im, bg_area, fg_area, area_resize_factor);
    
    %calculate and show precision plot, as well as frames-per-second
    precisions = precision_plot(results.res, params.bb_VOT, video, show_plots);
    fprintf('%12s - Precision (20px):% 1.3f, FPS:% 4.2f\n', video, precisions(20), results.fps)
    fclose('all');
    
end
